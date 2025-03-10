use anyhow::Result;
use gimli::{AttributeValue, Error};

pub(crate) fn clone_string_attribute<R: gimli::Reader>(
    dwarf: &gimli::Dwarf<R>,
    unit: &gimli::Unit<R, R::Offset>,
    attr: gimli::AttributeValue<R>,
) -> Result<String> {
    Ok(dwarf
        .attr_string(unit, attr)?
        .to_string()?
        .as_ref()
        .to_string())
}


pub(crate) fn clone_string_attribute_with_out_unit<R: gimli::Reader>(
    dwarf: &gimli::Dwarf<R>,
    attr: gimli::AttributeValue<R>,
) -> Result<String> {

    let string = match attr {
        AttributeValue::String(string) => Ok(string),
        AttributeValue::DebugStrRef(offset) => dwarf.string(offset),
        AttributeValue::DebugStrRefSup(offset) => dwarf.sup_string(offset),
        AttributeValue::DebugLineStrRef(offset) => dwarf.line_string(offset),
        // AttributeValue::DebugStrOffsetsIndex(index) => Ok("".to_string()),
        _ => Err(Error::ExpectedStringAttributeValue),
    };

    Ok(string?
        .to_string()?
        .as_ref()
        .to_string())
}
