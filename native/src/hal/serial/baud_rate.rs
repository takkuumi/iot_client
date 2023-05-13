use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

// 波特率 b7~b4
#[frb(dart_metadata = ("freezed"))]
#[repr(u16)]
#[derive(Serialize, Deserialize, Clone, Copy, PartialEq, Eq, Debug)]
pub enum BaudRate {
  BS300 = 0b_0001_0000_0000_0000,    // 1
  BS600 = 0b_0010_0000_0000_0000,    // 2
  BS1200 = 0b_0011_0000_0000_0000,   // 3
  BS2400 = 0b_0100_0000_0000_0000,   // 4
  BS4800 = 0b_0101_0000_0000_0000,   // 5
  BS9600 = 0b_0110_0000_0000_0000,   // 6
  BS19200 = 0b_0111_0000_0000_0000,  // 7
  BS115200 = 0b_1000_0000_0000_0000, // 8
}

impl std::ops::BitOr for BaudRate {
  type Output = u16;

  fn bitor(self, rhs: Self) -> Self::Output {
    self as u16 | rhs as u16
  }
}

impl TryFrom<u16> for BaudRate {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    // B12---B15波特率
    let byte = value >> 12;

    match byte {
      0b_0000_0000_0000_0001 => Ok(Self::BS300),
      0b_0000_0000_0000_0010 => Ok(Self::BS600),
      0b_0000_0000_0000_0011 => Ok(Self::BS1200),
      0b_0000_0000_0000_0100 => Ok(Self::BS2400),
      0b_0000_0000_0000_0101 => Ok(Self::BS4800),
      0b_0000_0000_0000_0110 => Ok(Self::BS9600),
      0b_0000_0000_0000_0111 => Ok(Self::BS19200),
      0b_0000_0000_0000_1000 => Ok(Self::BS115200),
      _ => Err(String::from("invalid bytes")),
    }
  }
}
