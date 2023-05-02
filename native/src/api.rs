use crate::hal::{self, Com};

use super::{
  ble::{at_command, BytesParse},
  hal::LogicControl,
  serial::SerialResponse,
};

pub fn ble_validate_response(data: Vec<u8>) -> bool {
  BytesParse::new(&data).validate()
}

pub fn ble_response_parse_u16(data: Vec<u8>, unit_id: u8) -> Option<u16> {
  BytesParse::new(&data).parse_u16(unit_id)
}

pub fn ble_get_ndid() -> SerialResponse {
  at_command::get_ndid()
}

pub fn ble_at_ndrpt(id: String, data: String, retry: u8) -> SerialResponse {
  at_command::at_ndrpt(&id, data.as_bytes(), retry)
}

pub fn ble_at_ndrpt_data(id: String, data: String, retry: u8) -> SerialResponse {
  at_command::at_ndrpt_data(&id, data.as_bytes(), retry)
}

pub fn ble_at_ndrpt_test() -> SerialResponse {
  at_command::at_ndrpt_test()
}

pub fn ble_set_ndid(id: String) -> SerialResponse {
  at_command::set_ndid(&id)
}

pub fn ble_set_mode(mode: u8) -> SerialResponse {
  at_command::set_mode(mode)
}

pub fn ble_ndreset() -> SerialResponse {
  at_command::ndreset()
}

pub fn ble_restore() -> SerialResponse {
  at_command::restore()
}
pub fn ble_reboot() -> SerialResponse {
  at_command::reboot()
}

pub fn hal_generate_get_holdings(unit_id: u8, reg: u16, count: u16) -> String {
  hex::encode_upper(LogicControl::generate_get_holdings(unit_id, reg, count))
}

pub fn hal_generate_set_holding(unit_id: u8, reg: u16, value: u16) -> String {
  hex::encode_upper(LogicControl::generate_set_holding(unit_id, reg, value))
}

pub fn hex_encode(data: Vec<u8>) -> String {
  hex::encode_upper(data)
}

pub fn hex_decode(data: String) -> Vec<u8> {
  hex::decode(data).unwrap_or_default()
}

pub fn hal_new_control(
  id: String,
  retry: u8,
  index: u8,
  scene: u8,
  com_in: hal::Com,
  com_out: hal::Com,
) -> bool {
  let logic_control = hal::LogicControl {
    index,
    scene,
    com_in,
    com_out,
  };
  let bytes = logic_control.bytes_u16();
  let mut start = 2300 + index as u16 * 10;
  for (index, value) in bytes.into_iter().enumerate() {
    let reg = start + index as u16;
    let data = hal::LogicControl::generate_set_holding(1, reg, value);

    if at_command::at_ndrpt_data(&id, &data, retry).is_err() {
      return false;
    }
  }

  true
}

pub fn hal_get_com_indexs(indexs: Vec<u8>) -> Com {
  let mut com = Com::default();
  for index in indexs {
    com.set_index(index + 1);
  }
  com
}

pub fn hal_read_logic_control(id: String, retry: u8, index: u8) -> Option<hal::LogicControl> {
  None
}
