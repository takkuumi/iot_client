use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[frb(dart_metadata = ("freezed"))]
#[repr(u16)]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub enum StopBit {
  Bit1 = 0b_0000_0000_0000_0000, // 1位停止位
  Bit2 = 0b_0000_0010_0000_0000, // 2位停止位
}

impl std::ops::BitOr for StopBit {
  type Output = u16;

  fn bitor(self, rhs: Self) -> Self::Output {
    self as u16 | rhs as u16
  }
}

impl TryFrom<u16> for StopBit {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    // 如：0b1111_1111_0001_0100 共 16位
    // 停止位 b3
    let byte = value >> 9 << 15;

    match byte {
      0b_0000_0000_0000_0000 => Ok(Self::Bit1),
      0b_1000_0000_0000_0000 => Ok(Self::Bit2),
      _ => Err(String::from("invalid bytes")),
    }
  }
}
