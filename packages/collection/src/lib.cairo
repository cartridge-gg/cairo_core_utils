pub mod collection_extend;
pub mod collection_split;
pub mod snap_forward;
pub mod span;
pub mod tuple;
pub use collection_extend::CollectionExtendFront;
pub use collection_split::CollectionSplit;
pub use snap_forward::{SnapForward, SnapForwardDeep, SnapForwardTo};
pub use span::ToSpan;
pub use tuple::IsTuple;

