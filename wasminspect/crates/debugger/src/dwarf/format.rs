use std::ops::{AddAssign, SubAssign};

use super::utils::*;

use anyhow::{anyhow, Context, Result};
use gimli::Unit;
use num_bigint::{BigInt, BigUint, Sign};

pub fn format_object<R: gimli::Reader>(
    node: gimli::EntriesTreeNode<R>,
    memory: &[u8],
    _encoding: gimli::Encoding,
    dwarf: &gimli::Dwarf<R>,
    unit: &Unit<R>,
) -> Result<String> {
    match node.entry().tag() {
        gimli::DW_TAG_base_type => {
            let entry = node.entry();
            let name = match entry.attr_value(gimli::DW_AT_name)? {
                Some(attr) => clone_string_attribute(dwarf, unit, attr)?,
                None => "<no type name>".to_string(),
            };
            let byte_size = entry
                .attr_value(gimli::DW_AT_byte_size)?
                .and_then(|attr| attr.udata_value())
                .with_context(|| "Failed to get byte_size".to_string())?;
            let encoding = entry
                .attr_value(gimli::DW_AT_encoding)?
                .and_then(|attr| match attr {
                    gimli::AttributeValue::Encoding(encoding) => Some(encoding),
                    _ => None,
                })
                .with_context(|| "Failed to get type encoding".to_string())?;
            let mut bytes = Vec::new();
            bytes.extend_from_slice(&memory[0..(byte_size as usize)]);

            match encoding {
                gimli::DW_ATE_signed => {
                    let v = BigInt::from_signed_bytes_le(&bytes);
                    Ok(format!("{}({})", name, v))
                }
                gimli::DW_ATE_unsigned => {
                    let value = BigUint::from_bytes_le(&bytes);
                    Ok(format!("{}({})", name, value))
                }
                gimli::DW_ATE_float => {
                    match bytes.len() {
                        4 => {
                            let mut f32_bytes = [0u8; 4];
                            f32_bytes.copy_from_slice(&bytes[..]);
                            let v = f32::from_le_bytes(f32_bytes);
                            Ok(format!("{}({})", name, v))
                        }
                        8 => {
                            let mut f64_bytes = [0u8; 8];
                            f64_bytes.copy_from_slice(&bytes[..]);
                            let v = f64::from_le_bytes(f64_bytes);
                            Ok(format!("{}({})", name, v))
                        }
                        _ => unimplemented!(),
                    }
                }
                _ => unimplemented!(),
            }
        }
        gimli::DW_TAG_class_type | gimli::DW_TAG_structure_type => {
            let entry = node.entry();
            let type_name = match entry.attr_value(gimli::DW_AT_name)? {
                Some(attr) => clone_string_attribute(dwarf, unit, attr)?,
                None => "<no type name>".to_string(),
            };
            let mut children = node.children();
            let mut members = vec![];
            while let Some(child) = children.next()? {
                match child.entry().tag() {
                    gimli::DW_TAG_member => {
                        let name = match child.entry().attr_value(gimli::DW_AT_name)? {
                            Some(attr) => clone_string_attribute(dwarf, unit, attr)?,
                            None => "<no member name>".to_string(),
                        };
                        // let ty = match entry.attr_value(gimli::DW_AT_type)? {
                        //     Some(gimli::AttributeValue::UnitRef(ref offset)) => offset.0,
                        //     _ => return Err(anyhow!("Failed to get type offset")),
                        // };
                        members.push(name);
                    }
                    _ => continue,
                }
            }
            Ok(format!("{} {{\n{}\n}}", type_name, members.join(",\n")))
        }
        _ => Err(anyhow!("unsupported DIE type")),
    }
}