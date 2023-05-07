use std::ops::{BitOr, Deref};

use bitflags::bitflags;
use rmodbus::{client::ModbusRequest, ModbusProto};

// The `bitflags!` macro generates `struct`s that manage a set of flags.
bitflags! {
  #[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
  pub struct Scenes: u8 {
    const A = 0b00000000;
    const B = 0b00000001;
    const C = 0b00000010;
    const D = 0b00000011;
    const E = 0b00000100;
    const F = 0b00000101;
    const G = 0b00000110;
    const H = 0b00000111;
    const I = 0b00001000;
    const J = 0b00001001;
    const K = 0b00001010;
    const L = 0b00001011;
    const M = 0b00001100;
    const N = 0b00001101;
    const O = 0b00001110;
    const P = 0b00001111;
    const Q = 0b00010000;
  }
}

#[derive(Debug)]
pub struct Index {
  pub index: u16,
  pub value: bool,
}

impl Index {
  pub fn offset(&mut self, offset: u16) -> &Self {
    self.index += offset;
    self
  }
}

#[derive(Default)]
pub struct Com(pub u32);

impl Deref for Com {
  type Target = u32;

  fn deref(&self) -> &Self::Target {
    &self.0
  }
}

impl BitOr for Com {
  type Output = Self;

  fn bitor(self, rhs: Self) -> Self::Output {
    Self(self.0 | rhs.0)
  }
}

impl Com {
  pub fn set_index(&mut self, index: u8) {
    self.0 |= 1 << (32 - index);
  }

  pub fn clear_index(&mut self, index: u8) {
    self.0 &= !(1 << (32 - index));
  }

  pub fn get_index(&self, index: u8) -> bool {
    self.0 & (1 << (32 - index)) != 0
  }

  pub fn set_value(&mut self, value: u32) {
    self.0 = value;
  }

  pub fn to_index(&self) -> Vec<Index> {
    let mut result = Vec::with_capacity(32);
    for i in 1..33 {
      let value = self.get_index(i);
      result.push(Index {
        index: i as u16,
        value,
      });
    }
    result
  }

  pub fn bits(&self) -> [u8; 4] {
    self.0.to_be_bytes()
  }
}

// |场景(u8高4位)|索引(u8低4位)|IO输入(u32)|IO输出(u32)|模式(u8)
pub struct LogicControl {
  pub index: u8,
  pub scene: u8,
  pub com_in: Com,
  pub com_out: Com,
}

impl LogicControl {
  pub fn bytes(&self) -> [u8; 10] {
    let mut result = [0u8; 10];
    result[0] = self.scene;
    result[1] = self.index;
    result[2..6].copy_from_slice(&self.com_in.bits());
    result[6..10].copy_from_slice(&self.com_out.bits());
    result
  }

  pub fn bytes_u16(&self) -> Vec<u16> {
    self
      .bytes()
      .chunks(2)
      .fold(Vec::<u16>::with_capacity(5), |mut res, item| {
        res.push(u16::from_be_bytes([item[0], item[1]]));
        res
      })
  }

  pub fn to_modbus(&self) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(1, ModbusProto::Rtu);

    let mut request = Vec::<u8>::new();
    mreq
      .generate_set_holdings_bulk(2300, &self.bytes_u16(), &mut request)
      .unwrap();

    request
  }

  pub fn generate_set_holdings(
    unit_id: u8,
    index: u8,
    scene: u8,
    v1: Vec<u8>,
    v2: Vec<u8>,
    v3: Vec<u8>,
    v4: Vec<u8>,
    v5: Vec<u8>,
    v6: Vec<u8>,
  ) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);

    let mut values = Vec::<u16>::with_capacity(5);

    values.push(u16::from_be_bytes([0, index]));
    values.push(u16::from_be_bytes([0, scene]));

    for ele in v1 {
      values.push(u16::from_be_bytes([0, ele]));
    }

    for ele in v2 {
      values.push(u16::from_be_bytes([0, ele]));
    }

    for ele in v3 {
      values.push(u16::from_be_bytes([0, ele]));
    }

    for ele in v4 {
      values.push(u16::from_be_bytes([0, ele]));
    }

    for ele in v5 {
      values.push(u16::from_be_bytes([0, ele]));
    }

    for ele in v6 {
      values.push(u16::from_be_bytes([0, ele]));
    }

    let mut request = Vec::<u8>::new();
    mreq
      .generate_set_holdings_bulk(2300, &values, &mut request)
      .unwrap();
    request
  }

  pub fn generate_set_holding(unit_id: u8, reg: u16, value: u16) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);

    let mut request = Vec::<u8>::new();
    mreq.generate_set_holding(reg, value, &mut request).unwrap();
    request
  }

  pub fn generate_get_holdings(unit_id: u8, reg: u16, count: u16) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);

    let mut request = Vec::<u8>::new();
    mreq
      .generate_get_holdings(reg, count, &mut request)
      .unwrap();
    request
  }

  pub fn generate_get_coils(unit_id: u8, reg: u16, count: u16) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);

    let mut request = Vec::<u8>::new();
    mreq.generate_get_coils(reg, count, &mut request).unwrap();
    request
  }

  pub fn generate_set_coils(unit_id: u8, reg: u16, values: &[bool]) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);

    let mut request = Vec::<u8>::new();
    mreq
      .generate_set_coils_bulk(reg, values, &mut request)
      .unwrap();
    request
  }
}

#[cfg(test)]
mod test {
  use crate::{
    ble::{at_command, BytesParse},
    hal::LogicControl,
  };
  use std::ops::{BitOr, Deref};

  #[test]
  fn it_works() {
    for i in 0..17 {
      eprintln!("    const {} = 0b{:08b};", (65 + i as u8) as char, i)
    }
  }

  #[test]
  fn logic_control_works() {
    let lc = super::LogicControl {
      index: 1,
      scene: super::Scenes::A.bits(),
      com_in: super::Com::default(),
      com_out: super::Com::default(),
    };

    let data = LogicControl::generate_set_holding(1, 2300, 1);

    let hex_str = hex::encode_upper(data);

    eprintln!("{:?}", hex_str);

    at_command::at_ndrpt_data("0001", hex_str.as_bytes(), 5);

    let hex_str = hex::encode_upper(LogicControl::generate_get_holdings(1, 2300, 1));
    eprintln!("{:?}", hex_str);
    let res = at_command::at_ndrpt_data("0001", hex_str.as_bytes(), 5);

    if let Some(bytes) = res.data {
      eprintln!("{:?}", bytes);
    }
  }
}
