use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

#[frb(dart_metadata = ("freezed"))]
#[repr(u16)]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub enum DataBit {
  BitWidth8 = 0b_0000_0000_0000_0000,
  BitWidth9 = 0b_0000_0001_0000_0000,
}

impl std::ops::BitOr for DataBit {
  type Output = u16;

  fn bitor(self, rhs: Self) -> Self::Output {
    self as u16 | rhs as u16
  }
}

impl TryFrom<u16> for DataBit {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    // B8 串口数据长度 	0为:8位  1为：9位
    let byte = value >> 8 << 15;

    match byte {
      0b_0000_0000_0000_0000 => Ok(Self::BitWidth8),
      0b_1000_0000_0000_0000 => Ok(Self::BitWidth9),
      _ => Err(String::from("invalid bytes")),
    }
  }
}

#[cfg(test)]
mod test {

  use super::DataBit;

  #[test]
  fn data_bit_test() {
    let value1 = 0b_0000_1110_1010_1110_u16;
    let value2 = 0b_0000_1111_1010_1111_u16;

    let a1 = DataBit::try_from(value1);

    assert!(a1.is_ok());
    let a1_str = format!("0b_{:0>16b}", a1.unwrap() as u16);

    assert_eq!("0b_0000000000000000", a1_str);

    let a2 = DataBit::try_from(value2);

    assert!(a2.is_ok());
    let a2_str = format!("0b_{:0>16b}", a2.unwrap() as u16);

    assert_eq!("0b_0000000100000000", a2_str);
  }
}
