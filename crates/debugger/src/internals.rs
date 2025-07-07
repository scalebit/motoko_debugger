use std::collections::HashMap;

lazy_static::lazy_static! {
    pub static ref INTERNAL_FILES: HashMap<&'static str, &'static str> = {
        let mut m = HashMap::new();
        m.insert("./internals", include_str!("source_code_in_moc/internals.mo"));
        m.insert("<moc-asset>/prim", include_str!("source_code_in_moc/prim.mo"));
        m.insert("<moc-asset>/prelude", include_str!("source_code_in_moc/prelude.mo"));
        m
    };
}
