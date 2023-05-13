use crate::{
  hal::device::{DeviceDisplay, DeviceSetting},
  serial::DataType,
};

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

// pub fn ble_at_ndrpt(id: String, data: String, retry: u8) -> SerialResponse {
//   at_command::at_ndrpt(&id, data.as_bytes(), retry)
// }

// pub fn ble_at_ndrpt_data(id: String, data: String, retry: u8) -> SerialResponse {
//   at_command::at_ndrpt_data(&id, data.as_bytes(), retry)
// }

// pub fn ble_at_ndrpt_test() -> SerialResponse {
//   at_command::at_ndrpt_test()
// }

// 搜索附近的设备
pub fn ble_scan(typee: u8) -> SerialResponse {
  at_command::scan(typee)
}

pub fn ble_lecconn(addr: String, add_type: u8) -> bool {
  at_command::lecconn(addr.as_str(), add_type)
}

pub fn ble_ledisc(index: u8) -> bool {
  at_command::ledisc(index)
}

pub fn ble_lesend(index: u8, data: String) -> SerialResponse {
  at_command::lesend(index, data.as_str())
}

pub fn ble_tpmode() {
  at_command::tpmode();
}

pub fn ble_reboot() {
  at_command::reboot();
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

// Future<List<int>> readDevice() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   int? index = prefs.getInt("no");
//   if (index == null) {
//     throw Exception("未设置连接");
//   }

//   String? mac = prefs.getString("mac");
//   if (mac == null) {
//     throw Exception("未设置连接");
//   }
//   List<int> data1 = await getHoldings(2196, 40);
//   List<int> data2 = await getHoldings(2236, 40);

//   List<int> data = data1 + data2;

//   prefs.setString(mac, data.join(","));

//   return data;
// }

// String data =
// await api.halGenerateGetHoldings(unitId: 1, reg: reg, count: count);
// debugPrint('getHolding: $data');
// SerialResponse sr = await api.bleLesend(index: index, data: data);
// Uint8List? rdata = sr.data;
// if (rdata == null) {
// return res;
// }

pub fn hal_read_device_settings(index: u8) -> Option<DeviceDisplay> {
  let rtu_req = LogicControl::generate_get_holdings(1, 2196, 40);
  let resp1 = at_command::lesend(index, &hex_encode(rtu_req));
  if resp1.is_err() {
    return None;
  }
  let rtu_req = LogicControl::generate_get_holdings(1, 2236, 40);
  let resp2 = at_command::lesend(index, &hex_encode(rtu_req));

  if resp2.is_err() {
    return None;
  }

  let v1 = resp1
    .data
    .and_then(|data| BytesParse::new(&data).parse_u16());
  let v2 = resp2
    .data
    .and_then(|data| BytesParse::new(&data).parse_u16());

  if v1.is_none() || v2.is_none() {
    return None;
  }

  let mut data = Vec::new();
  data.extend(v1.unwrap());
  data.extend(v2.unwrap());

  if let Ok(ds) = DeviceSetting::try_from(data) {
    return DeviceDisplay::try_from(ds).ok();
  }
  None
}
