use serde::{Deserialize, Serialize};

#[repr(u16)]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub enum PortType {
  Nil = 0b_0000_0000_0000_0000,
  Master = 0b_0000_0000_0000_0001,
  Slave = 0b_0000_0000_0000_0010,
}

impl std::ops::BitOr for PortType {
  type Output = u16;

  fn bitor(self, rhs: Self) -> Self::Output {
    self as u16 | rhs as u16
  }
}

impl TryFrom<u16> for PortType {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    // B0B1 端口功能	00端口未启用,01端口做主站,10 端口做从站
    let byte = value << 14;

    match byte {
      0b_0000_0000_0000_0000 => Ok(Self::Nil),
      0b_0100_0000_0000_0000 => Ok(Self::Master),
      0b_1000_0000_0000_0000 => Ok(Self::Slave),
      _ => Err(String::from("invalid bytes")),
    }
  }
}
