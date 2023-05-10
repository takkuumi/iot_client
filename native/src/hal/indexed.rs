#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Indexed<T> {
  /// Address of the value
  pub index: u16,
  /// Associated value
  pub value: T,
}
