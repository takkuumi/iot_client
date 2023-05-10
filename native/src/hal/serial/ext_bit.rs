use serde::{Deserialize, Serialize};

#[repr(u16)]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub enum ExtBit {
  Def = 0b_0000_0000_0000_0000,
}

impl std::ops::BitOr for ExtBit {
  type Output = u16;

  fn bitor(self, rhs: Self) -> Self::Output {
    self as u16 | rhs as u16
  }
}

impl TryFrom<u16> for ExtBit {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    // 如：0b1111_1111_0001_0100 共 16位
    // 波特率取 b7~b4
    // 清理高8位和低4位
    let byte = value >> 8 << 13;

    match byte {
      0b_0000_0000_0000_0000 => Ok(Self::Def),
      _ => Err(String::from("invalid bytes")),
    }
  }
}
