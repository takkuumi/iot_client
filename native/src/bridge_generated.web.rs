use super::*;
// Section: wire functions

#[wasm_bindgen]
pub fn wire_init_log(port_: MessagePort) {
  wire_init_log_impl(port_)
}

#[wasm_bindgen]
pub fn wire_ble_validate_response(port_: MessagePort, data: Box<[u8]>) {
  wire_ble_validate_response_impl(port_, data)
}

#[wasm_bindgen]
pub fn wire_ble_response_parse_u16(port_: MessagePort, data: Box<[u8]>) {
  wire_ble_response_parse_u16_impl(port_, data)
}

#[wasm_bindgen]
pub fn wire_ble_response_parse_bool(port_: MessagePort, data: Box<[u8]>) {
  wire_ble_response_parse_bool_impl(port_, data)
}

#[wasm_bindgen]
pub fn wire_ble_ports(port_: MessagePort) {
  wire_ble_ports_impl(port_)
}

#[wasm_bindgen]
pub fn wire_ble_scan(port_: MessagePort, typee: u8) {
  wire_ble_scan_impl(port_, typee)
}

#[wasm_bindgen]
pub fn wire_ble_lecconn(port_: MessagePort, addr: String, add_type: u8) {
  wire_ble_lecconn_impl(port_, addr, add_type)
}

#[wasm_bindgen]
pub fn wire_ble_ledisc(port_: MessagePort, index: u8) {
  wire_ble_ledisc_impl(port_, index)
}

#[wasm_bindgen]
pub fn wire_ble_lesend(port_: MessagePort, index: u8, data: String) {
  wire_ble_lesend_impl(port_, index, data)
}

#[wasm_bindgen]
pub fn wire_ble_tpmode(port_: MessagePort) {
  wire_ble_tpmode_impl(port_)
}

#[wasm_bindgen]
pub fn wire_ble_reboot(port_: MessagePort) {
  wire_ble_reboot_impl(port_)
}

#[wasm_bindgen]
pub fn wire_ble_chinfo(port_: MessagePort) {
  wire_ble_chinfo_impl(port_)
}

#[wasm_bindgen]
pub fn wire_ble_uartcfg(port_: MessagePort) {
  wire_ble_uartcfg_impl(port_)
}

#[wasm_bindgen]
pub fn wire_hal_generate_get_holdings(port_: MessagePort, unit_id: u8, reg: u16, count: u16) {
  wire_hal_generate_get_holdings_impl(port_, unit_id, reg, count)
}

#[wasm_bindgen]
pub fn wire_hal_generate_get_coils(port_: MessagePort, unit_id: u8, reg: u16, count: u16) {
  wire_hal_generate_get_coils_impl(port_, unit_id, reg, count)
}

#[wasm_bindgen]
pub fn wire_hal_generate_set_coils(port_: MessagePort, unit_id: u8, reg: u16, values: Box<[u8]>) {
  wire_hal_generate_set_coils_impl(port_, unit_id, reg, values)
}

#[wasm_bindgen]
pub fn wire_hal_generate_set_coil(port_: MessagePort, unit_id: u8, reg: u16, value: u8) {
  wire_hal_generate_set_coil_impl(port_, unit_id, reg, value)
}

#[wasm_bindgen]
pub fn wire_hal_generate_set_holding(port_: MessagePort, unit_id: u8, reg: u16, value: u16) {
  wire_hal_generate_set_holding_impl(port_, unit_id, reg, value)
}

#[wasm_bindgen]
pub fn wire_hal_generate_set_holdings_bulk(
  port_: MessagePort,
  unit_id: u8,
  reg: u16,
  values: Box<[u16]>,
) {
  wire_hal_generate_set_holdings_bulk_impl(port_, unit_id, reg, values)
}

#[wasm_bindgen]
pub fn wire_hex_encode(port_: MessagePort, data: Box<[u8]>) {
  wire_hex_encode_impl(port_, data)
}

#[wasm_bindgen]
pub fn wire_hex_decode(port_: MessagePort, data: String) {
  wire_hex_decode_impl(port_, data)
}

#[wasm_bindgen]
pub fn wire_hal_new_logic_control(port_: MessagePort, index: u8, scene: u8, values: Box<[u8]>) {
  wire_hal_new_logic_control_impl(port_, index, scene, values)
}

#[wasm_bindgen]
pub fn wire_hal_generate_set_lc_holdings(port_: MessagePort, unit_id: u8, logic_control: JsValue) {
  wire_hal_generate_set_lc_holdings_impl(port_, unit_id, logic_control)
}

#[wasm_bindgen]
pub fn wire_convert_u16s_to_u8s(port_: MessagePort, data: Box<[u16]>) {
  wire_convert_u16s_to_u8s_impl(port_, data)
}

#[wasm_bindgen]
pub fn wire_hal_read_device_settings(port_: MessagePort, index: u8) {
  wire_hal_read_device_settings_impl(port_, index)
}

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for String {
  fn wire2api(self) -> String {
    self
  }
}

impl Wire2Api<LogicControl> for JsValue {
  fn wire2api(self) -> LogicControl {
    let self_ = self.dyn_into::<JsArray>().unwrap();
    assert_eq!(
      self_.length(),
      3,
      "Expected 3 elements, got {}",
      self_.length()
    );
    LogicControl {
      index: self_.get(0).wire2api(),
      scene: self_.get(1).wire2api(),
      values: self_.get(2).wire2api(),
    }
  }
}

impl Wire2Api<Vec<u16>> for Box<[u16]> {
  fn wire2api(self) -> Vec<u16> {
    self.into_vec()
  }
}
impl Wire2Api<Vec<u8>> for Box<[u8]> {
  fn wire2api(self) -> Vec<u8> {
    self.into_vec()
  }
}
// Section: impl Wire2Api for JsValue

impl Wire2Api<String> for JsValue {
  fn wire2api(self) -> String {
    self.as_string().expect("non-UTF-8 string, or not a string")
  }
}
impl Wire2Api<u16> for JsValue {
  fn wire2api(self) -> u16 {
    self.unchecked_into_f64() as _
  }
}
impl Wire2Api<u8> for JsValue {
  fn wire2api(self) -> u8 {
    self.unchecked_into_f64() as _
  }
}
impl Wire2Api<Vec<u16>> for JsValue {
  fn wire2api(self) -> Vec<u16> {
    self.unchecked_into::<js_sys::Uint16Array>().to_vec().into()
  }
}
impl Wire2Api<Vec<u8>> for JsValue {
  fn wire2api(self) -> Vec<u8> {
    self.unchecked_into::<js_sys::Uint8Array>().to_vec().into()
  }
}
