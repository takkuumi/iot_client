use serde::{Deserialize, Serialize};

#[repr(u16)]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub enum Undefine {
  Def = 0b_0000_0000_0000_0000,
}

impl std::ops::BitOr for Undefine {
  type Output = u16;

  fn bitor(self, rhs: Self) -> Self::Output {
    self as u16 | rhs as u16
  }
}

impl TryFrom<u16> for Undefine {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    // 如：0b1111_1111_0001_0100 共 16位
    // 停止位 b3
    let byte = value >> 2 << 10;

    match byte {
      0b_0000_0000_0000_0000 => Ok(Self::Def),
      _ => Err(String::from("invalid bytes")),
    }
  }
}
