use super::{
  ble::{at_command, BytesParse},
  hal::LogicControl,
  serial::SerialResponse,
};

pub fn ble_validate_response(data: Vec<u8>) -> bool {
  BytesParse::new(&data).validate()
}

pub fn ble_response_parse_u16(data: Vec<u8>) -> Option<Vec<u16>> {
  BytesParse::new(&data).parse_u16()
}

pub fn ble_response_parse_bool(data: Vec<u8>) -> Option<Vec<u8>> {
  BytesParse::new(&data).parse_bool()
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

// 搜索附近的设备
pub fn ble_scan(typee: u8) -> SerialResponse {
  at_command::scan(typee)
}

pub fn ble_lecconn(addr: String, add_type: u8) -> SerialResponse {
  at_command::lecconn(addr.as_str(), add_type)
}
pub fn ble_lecconn_addr(addr: String) -> SerialResponse {
  at_command::lecconn_addr(addr.as_str())
}

pub fn ble_ledisc(index: u8) -> SerialResponse {
  at_command::ledisc(index)
}

pub fn ble_lesend(index: u8, data: String) -> SerialResponse {
  at_command::lesend(index, data.as_str())
}

pub fn ble_chinfo() -> SerialResponse {
  at_command::chinfo()
}

pub fn ble_uartcfg() -> SerialResponse {
  at_command::uartcfg()
}

pub fn hal_generate_get_holdings(unit_id: u8, reg: u16, count: u16) -> String {
  hex::encode_upper(LogicControl::generate_get_holdings(unit_id, reg, count))
}

pub fn hal_generate_get_coils(unit_id: u8, reg: u16, count: u16) -> String {
  hex::encode_upper(LogicControl::generate_get_coils(unit_id, reg, count))
}

pub fn hal_generate_set_coils(unit_id: u8, reg: u16, values: Vec<u8>) -> String {
  let mut result = Vec::new();
  for value in values {
    result.push(value != 0);
  }
  hex::encode_upper(LogicControl::generate_set_coils(unit_id, reg, &result))
}

pub fn hal_generate_set_coil(unit_id: u8, reg: u16, value: u8) -> String {
  let value = value != 0;
  hex::encode_upper(LogicControl::generate_set_coil(unit_id, reg, value))
}

pub fn hal_generate_set_holding(unit_id: u8, reg: u16, value: u16) -> String {
  hex::encode_upper(LogicControl::generate_set_holding(unit_id, reg, value))
}

pub fn hal_generate_set_holdings_bulk(unit_id: u8, reg: u16, values: Vec<u16>) -> String {
  let res = LogicControl::generate_set_holdings_bulk(unit_id, reg, values);

  hex::encode_upper(res)
}

pub fn hex_encode(data: Vec<u8>) -> String {
  hex::encode_upper(data)
}

pub fn hex_decode(data: String) -> Vec<u8> {
  hex::decode(data).unwrap_or_default()
}

pub fn hal_new_logic_control(index: u8, scene: u8, values: Vec<u8>) -> LogicControl {
  LogicControl {
    index,
    scene,
    values,
  }
}

pub fn hal_generate_set_lc_holdings(unit_id: u8, logic_control: LogicControl) -> String {
  let LogicControl {
    index,
    scene,
    values,
  } = logic_control;
  let res = LogicControl::generate_set_holdings(unit_id, index, scene, &values);

  hex::encode_upper(res)
}

pub fn convert_u16s_to_u8s(data: Vec<u16>) -> Vec<u8> {
  let mut result = Vec::new();
  for value in data {
    result.push((value >> 8) as u8);
    result.push(value as u8);
  }
  result
}
