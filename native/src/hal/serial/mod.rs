#![deny(clippy::pedantic)]
pub mod baud_rate;
pub mod data_bit;
pub mod ext_bit;
pub mod parity;
pub mod port_type;
pub mod protocol;
pub mod stop_bit;
pub mod undefine;

use baud_rate::BaudRate;
use data_bit::DataBit;
use flutter_rust_bridge::frb;
use parity::Parity;
use port_type::PortType;
use serde::{Deserialize, Serialize};
use stop_bit::StopBit;
use undefine::Undefine;

pub trait SettingDefault {
  fn rs485() -> Self;
  fn bluetooth() -> Self;
  fn net() -> Self;
}

#[frb(dart_metadata = ("freezed"))]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub struct Setting {
  pub configuration: Configuration,
  pub slave_addr: u16,
  pub retry: u16,
  pub duration: u16,
  pub loop_interval: u16,
}

impl SettingDefault for Setting {
  fn rs485() -> Self {
    let configuration = Configuration::default();
    Self {
      configuration,
      slave_addr: 1,
      retry: 2,
      duration: 100,
      loop_interval: 50,
    }
  }

  fn bluetooth() -> Self {
    let configuration = Configuration::default();
    Self {
      configuration,
      slave_addr: 1,
      retry: 1,
      duration: 100,
      loop_interval: 1000,
    }
  }

  fn net() -> Self {
    let configuration = Configuration::default();
    Self {
      configuration,
      slave_addr: 1,
      retry: 2,
      duration: 100,
      loop_interval: 100,
    }
  }
}

impl<'s> TryFrom<&'s [u16]> for Setting {
  type Error = String;

  fn try_from(value: &'s [u16]) -> Result<Self, Self::Error> {
    if value.len() < 5 {
      return Err(String::from("invalid bytes"));
    }

    let configuration = Configuration::try_from(value[0])?;

    Ok(Self {
      configuration,
      slave_addr: value[1],
      retry: value[2],
      duration: value[3],
      loop_interval: value[4],
    })
  }
}

impl TryFrom<Vec<u16>> for Setting {
  type Error = String;

  fn try_from(value: Vec<u16>) -> Result<Self, Self::Error> {
    Self::try_from(value.as_slice())
  }
}
impl TryInto<Vec<u16>> for Setting {
  type Error = String;

  fn try_into(self) -> Result<Vec<u16>, Self::Error> {
    let Self {
      configuration,
      slave_addr,
      retry,
      duration,
      loop_interval,
    } = self;
    let conf: u16 = configuration.try_into()?;

    Ok(vec![conf, slave_addr, retry, duration, loop_interval])
  }
}

// |    |  A  |     B     |   C    |                           D
// |
// |----|-----|-----------|--------|-------------------------------------------------------|
// |  1 |     |           |        |
// | |  2 | 低8位 | B0B1      | 端口功能   | 00端口未启用,01端口做主站,10
// 端口做从站                              | |  3 |     | B2        | 未定义
// |                                                       | |  4 |     | B3
// | 未定义    |                                                       | |  5 |
// | B4        | 未定义    |
// | |  6 |     | B5        | 未定义    |
// | |  7 |     | B6        | 未定义    |
// | |  8 |     | B7        | 未定义    |
// | |  9 | 高8位 | B8        | 串口数据长度 | 0为:8位  1为：9位
// | | 10 |     | B9        | 停止位    | 0为：1位停止位  1为：2位停止位
// | | 11 |     | B10B11    | 校验方式   | 00：无奇偶校验  01:奇校验 10：偶校验
// | | 12 |     | B12---B15 | 波特率    | "1(0001):300bit/s 2(0010):600bit/s
// 3(0011)：1200bit/s  | | 13 |     |           |        | 4(0100):2400bit/s
// 5(0101)：4800bit/s 6(0110):9600bit/s | | 14 |     |           |        |
// 7(0111)：19200bit/s   8(1000)::115200bit/s"            |

#[frb(dart_metadata = ("freezed"))]
#[derive(Serialize, Deserialize, PartialEq, Eq, Debug)]
pub struct Configuration {
  pub data_bit: DataBit,   // 串口数据长度     0为:8位  1为：9位
  pub parity: Parity,      // 校验方式   00：无奇偶校验  01:奇校验 10：偶校验
  pub stop_bit: StopBit,   // 停止位     0为：1位停止位  1为：2位停止位
  pub baud_rate: BaudRate, // 波特率
  pub undefine: Undefine,  // 未定义
  pub port_type: PortType, // 端口功能
}

impl Default for Configuration {
  fn default() -> Self {
    Self {
      data_bit: DataBit::BitWidth8,
      parity: Parity::Nil,
      stop_bit: StopBit::Bit1,
      baud_rate: BaudRate::BS115200,
      undefine: Undefine::Def,
      port_type: PortType::Slave,
    }
  }
}

impl TryFrom<u16> for Configuration {
  type Error = String;

  fn try_from(value: u16) -> Result<Self, Self::Error> {
    let data_bit = DataBit::try_from(value)?;
    let parity: Parity = Parity::try_from(value)?;
    let stop_bit: StopBit = StopBit::try_from(value)?;
    let baud_rate: BaudRate = BaudRate::try_from(value)?;
    let undefine: Undefine = Undefine::try_from(value)?;
    let port_type: PortType = PortType::try_from(value)?;

    Ok(Self {
      data_bit,
      parity,
      stop_bit,
      baud_rate,
      undefine,
      port_type,
    })
  }
}

impl TryInto<u16> for Configuration {
  type Error = String;

  fn try_into(self) -> Result<u16, Self::Error> {
    let Self {
      data_bit,
      parity,
      stop_bit,
      baud_rate,
      undefine,
      port_type,
    } = self;

    let res: u16 = data_bit as u16
      | parity as u16
      | stop_bit as u16
      | baud_rate as u16
      | undefine as u16
      | port_type as u16;

    Ok(res)
  }
}

#[cfg(test)]
mod test {

  use super::{
    baud_rate::BaudRate,
    data_bit::DataBit,
    parity::Parity,
    port_type::PortType,
    stop_bit::StopBit,
    undefine::Undefine,
    Configuration,
  };

  // 数据长度   b0         9位        （0为:8位  1为：9位）
  // 校验方式   b1b2       奇校验      （00：无奇偶校验  01:奇校验 11：偶校验）
  // 停止位     b3         2位停止位    (0为：1位停止位  1为：2位停止位)
  // 波特率     b7b6b5b4   9600bit/s   1(0001)为：300bit/s    2(0010)为:600bit/s
  //                                  3(0011)为：1200bit/s
  // 4(0100)为：2400bit/s
  // 5(0101)为：4800bit/s   6(0110)为9600bit/s
  // 7(0111)为：19200bit/s   8(1000)为：115200 备用扩展位   b10b9b8  默认为0
  // 默认为0，备用扩展位 通信协议     b11      1
  // 0为：自定义协议，1为:Modbus RTU 通信接口备用 b14b13b12 默认000
  // 000为：无 001为：RS485-1 010为RS485-2 011为：RS485-3 端口做主从   b15
  // 1 0为：从站（服务端），1为:主站（客服端）

  // 0110000000000010
  const RS485_MOCK_1: u16 = 0b_0110_0000_0000_0010; // 32770

  #[test]
  fn convert() {
    // let a = Configuration::default();
    // let b = std::convert::TryInto::<u16>::try_into(a).unwrap();
    // // let c = u16::from_be(a.baud_rate as u16);

    // eprintln!("{}", format!("{:#0b}", b));

    let config = std::convert::TryInto::<Configuration>::try_into(32770).unwrap();

    eprintln!("{config:?}");

    let config = Configuration {
      data_bit: DataBit::BitWidth8,
      parity: Parity::Nil,
      stop_bit: StopBit::Bit1,
      baud_rate: BaudRate::BS115200,
      undefine: Undefine::Def,
      port_type: PortType::Slave,
    };

    let b = std::convert::TryInto::<u16>::try_into(config).unwrap();

    eprintln!("{b}");
  }
  #[test]
  fn it_works() {
    let rs485_1 = Configuration::try_from(RS485_MOCK_1);

    assert!(rs485_1.is_ok());

    let json_str = serde_json::to_string(&rs485_1.unwrap());

    assert!(json_str.is_ok());

    let str = json_str.unwrap();
    let dec = serde_json::from_str::<Configuration>(&str);

    assert!(dec.is_ok());

    let Configuration { baud_rate, .. } = dec.unwrap();

    assert_eq!(baud_rate, BaudRate::BS9600);
    // assert_eq!(stop_bit as u16, 0b_1_u16);
    // assert_eq!(baud_rate as u16, 0b_1_u16);
    // assert_eq!(ext_bit as u16, 0b_1_u16);
    // assert_eq!(protocol as u16, 0b_1_u16);
    // assert_eq!(port as u16, 0b_1_u16);
    // assert_eq!(port_type as u16, 0b_1_u16);
  }
}
