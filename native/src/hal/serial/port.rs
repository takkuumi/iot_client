use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[frb(dart_metadata = ("freezed"))]
#[repr(u16)]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub enum Port {
  Nil = 0b_0000_0000_0000_0000,
  RS485_1 = 0b_0001_0000_0000_0000,
  RS485_2 = 0b_0010_0000_0000_0000,
  RS485_3 = 0b_0011_0000_0000_0000,
}

impl std::ops::BitOr for Port {
  type Output = u16;

  fn bitor(self, rhs: Self) -> Self::Output {
    self as u16 | rhs as u16
  }
}

impl TryFrom<u16> for Port {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    // 如：0b1111_1111_0001_0100 共 16位
    // 波特率取 b7~b4
    //清理高8位和低4位
    let byte = value << 1 >> 13;

    match byte {
      0b_0000_0000_0000_0000 => Ok(Self::Nil),
      0b_0000_0000_0000_0001 => Ok(Self::RS485_1),
      0b_0000_0000_0000_0010 => Ok(Self::RS485_2),
      0b_0000_0000_0000_0011 => Ok(Self::RS485_3),
      _ => Err(String::from("invalid bytes")),
    }
  }
}
