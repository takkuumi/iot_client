pub mod device;
pub mod eui48;
pub mod indexed;
pub mod memory;
pub mod serial;
pub mod utils;

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

// |场景(u8高4位)|索引(u8低4位)|IO输入(u32)|IO输出(u32)|模式(u8)
pub struct LogicControl {
  pub index: u8,
  pub scene: u8,
  pub values: Vec<u8>,
}

impl LogicControl {
  pub fn bytes(&self) -> [u8; 8] {
    let mut result = [0u8; 8];
    result[0] = self.index;
    result[1] = self.scene;
    result[2..8].copy_from_slice(&self.values);
    result
  }

  pub fn bytes_u16(&self) -> Vec<u16> {
    self
      .bytes()
      .chunks(2)
      .fold(Vec::<u16>::with_capacity(4), |mut res, item| {
        res.push(u16::from_be_bytes([item[0], item[1]]));
        res
      })
  }

  pub fn to_modbus(&self) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(1, ModbusProto::Rtu);

    let mut request = Vec::<u8>::new();
    mreq
      .generate_set_holdings_bulk(
        2300 + (self.index as u16) * 12,
        &self.bytes_u16(),
        &mut request,
      )
      .unwrap();

    request
  }

  pub fn generate_set_holdings(unit_id: u8, index: u8, scene: u8, values: &[u8]) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);

    let mut req_values = Vec::<u16>::with_capacity(5);

    req_values.push(u16::from_be_bytes([index, scene]));

    let chunks = values.chunks_exact(2);
    let rem = chunks.remainder();

    for chunk in chunks {
      req_values.push(u16::from_be_bytes([chunk[0], chunk[1]]));
    }

    if rem.len() == 1 {
      req_values.push(u16::from_be_bytes([rem[0], 0]));
    }

    let mut request = Vec::<u8>::new();
    mreq
      .generate_set_holdings_bulk(2300 + (index as u16) * 12, &req_values, &mut request)
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

  pub fn generate_set_holdings_bulk(unit_id: u8, reg: u16, values: Vec<u16>) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);

    let mut request = Vec::<u8>::new();
    mreq
      .generate_set_holdings_bulk(reg, &values, &mut request)
      .unwrap();
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

  pub fn generate_set_coil(unit_id: u8, reg: u16, value: bool) -> Vec<u8> {
    // create request object
    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);

    let mut request = Vec::<u8>::new();
    mreq.generate_set_coil(reg, value, &mut request).unwrap();
    request
  }
}

#[cfg(test)]
mod test {
  use std::eprintln;

  use crate::ble::at_command;

  use super::LogicControl;

  #[test]
  fn it_works() {
    let rtu_req = LogicControl::generate_get_holdings(1, 2176, 58);
    let hs = hex::encode_upper(rtu_req);
    let data = format!("AT+LESEND={},{},{}\\r\\n", 0, hs.len(), hs);
    eprintln!("{}", data);
  }
}
