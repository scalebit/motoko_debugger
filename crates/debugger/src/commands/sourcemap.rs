use std::num::NonZero;

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum ColumnType {
    LeftEdge,
    // Column(NonZero<u64>),
    Column(u64),
}

impl From<ColumnType> for u64 {
    fn from(val: ColumnType) -> Self {
        match val {
            ColumnType::Column(c) => c,
            ColumnType::LeftEdge => 0,
        }
    }
}

#[derive(Clone, Debug)]
pub struct LineInfo {
    pub filepath: String,
    // pub line: Option<NonZero<u64>>,
    pub line: Option<u64>,
    pub column: ColumnType,
}

pub trait SourceMap {
    fn find_line_info(&self, offset: usize) -> Option<LineInfo>;
    fn set_directory_map(&self, from: String, to: String);
    fn inst_in_file_0(&self) -> Vec<u64>;
}

pub struct EmptySourceMap {}

impl EmptySourceMap {
    pub fn new() -> Self {
        Self {}
    }
}
impl SourceMap for EmptySourceMap {
    fn find_line_info(&self, _: usize) -> Option<LineInfo> {
        None
    }
    fn set_directory_map(&self, _: String, _: String) {}
    fn inst_in_file_0(&self) -> Vec<u64> {
        vec![]
    }
}
