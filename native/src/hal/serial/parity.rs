use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[frb(dart_metadata = ("freezed"))]
#[repr(u16)]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub enum Parity {
  Nil = 0b_0000_0000_0000_0000,  // 无奇偶校验
  Odd = 0b_0000_0100_0000_0000,  // 奇校验
  Even = 0b_0000_1000_0000_0000, // 偶校验
}

impl std::ops::BitOr for Parity {
  type Output = u16;

  fn bitor(self, rhs: Self) -> Self::Output {
    self as u16 | rhs as u16
  }
}

impl TryFrom<u16> for Parity {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    // B10B11 校验方式	00：无奇偶校验  01:奇校验 10：偶校验
    let byte = value >> 10 << 14;

    match byte {
      0b_0000_0000_0000_0000 => Ok(Self::Nil),
      0b_0100_0000_0000_0000 => Ok(Self::Odd),
      0b_1000_0000_0000_0000 => Ok(Self::Even),
      _ => Err(String::from("invalid bytes")),
    }
  }
}
