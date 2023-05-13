use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_ble_validate_response(port_: i64, data: *mut wire_uint_8_list) {
  wire_ble_validate_response_impl(port_, data)
}

#[no_mangle]
pub extern "C" fn wire_ble_response_parse_u16(port_: i64, data: *mut wire_uint_8_list) {
  wire_ble_response_parse_u16_impl(port_, data)
}

#[no_mangle]
pub extern "C" fn wire_ble_response_parse_bool(port_: i64, data: *mut wire_uint_8_list) {
  wire_ble_response_parse_bool_impl(port_, data)
}

#[no_mangle]
pub extern "C" fn wire_ble_scan(port_: i64, typee: u8) {
  wire_ble_scan_impl(port_, typee)
}

#[no_mangle]
pub extern "C" fn wire_ble_lecconn(port_: i64, addr: *mut wire_uint_8_list, add_type: u8) {
  wire_ble_lecconn_impl(port_, addr, add_type)
}

#[no_mangle]
pub extern "C" fn wire_ble_ledisc(port_: i64, index: u8) {
  wire_ble_ledisc_impl(port_, index)
}

#[no_mangle]
pub extern "C" fn wire_ble_lesend(port_: i64, index: u8, data: *mut wire_uint_8_list) {
  wire_ble_lesend_impl(port_, index, data)
}

#[no_mangle]
pub extern "C" fn wire_ble_tpmode(port_: i64) {
  wire_ble_tpmode_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_ble_chinfo(port_: i64) {
  wire_ble_chinfo_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_ble_uartcfg(port_: i64) {
  wire_ble_uartcfg_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_hal_generate_get_holdings(port_: i64, unit_id: u8, reg: u16, count: u16) {
  wire_hal_generate_get_holdings_impl(port_, unit_id, reg, count)
}

#[no_mangle]
pub extern "C" fn wire_hal_generate_get_coils(port_: i64, unit_id: u8, reg: u16, count: u16) {
  wire_hal_generate_get_coils_impl(port_, unit_id, reg, count)
}

#[no_mangle]
pub extern "C" fn wire_hal_generate_set_coils(
  port_: i64,
  unit_id: u8,
  reg: u16,
  values: *mut wire_uint_8_list,
) {
  wire_hal_generate_set_coils_impl(port_, unit_id, reg, values)
}

#[no_mangle]
pub extern "C" fn wire_hal_generate_set_coil(port_: i64, unit_id: u8, reg: u16, value: u8) {
  wire_hal_generate_set_coil_impl(port_, unit_id, reg, value)
}

#[no_mangle]
pub extern "C" fn wire_hal_generate_set_holding(port_: i64, unit_id: u8, reg: u16, value: u16) {
  wire_hal_generate_set_holding_impl(port_, unit_id, reg, value)
}

#[no_mangle]
pub extern "C" fn wire_hal_generate_set_holdings_bulk(
  port_: i64,
  unit_id: u8,
  reg: u16,
  values: *mut wire_uint_16_list,
) {
  wire_hal_generate_set_holdings_bulk_impl(port_, unit_id, reg, values)
}

#[no_mangle]
pub extern "C" fn wire_hex_encode(port_: i64, data: *mut wire_uint_8_list) {
  wire_hex_encode_impl(port_, data)
}

#[no_mangle]
pub extern "C" fn wire_hex_decode(port_: i64, data: *mut wire_uint_8_list) {
  wire_hex_decode_impl(port_, data)
}

#[no_mangle]
pub extern "C" fn wire_hal_new_logic_control(
  port_: i64,
  index: u8,
  scene: u8,
  values: *mut wire_uint_8_list,
) {
  wire_hal_new_logic_control_impl(port_, index, scene, values)
}

#[no_mangle]
pub extern "C" fn wire_hal_generate_set_lc_holdings(
  port_: i64,
  unit_id: u8,
  logic_control: *mut wire_LogicControl,
) {
  wire_hal_generate_set_lc_holdings_impl(port_, unit_id, logic_control)
}

#[no_mangle]
pub extern "C" fn wire_convert_u16s_to_u8s(port_: i64, data: *mut wire_uint_16_list) {
  wire_convert_u16s_to_u8s_impl(port_, data)
}

#[no_mangle]
pub extern "C" fn wire_hal_read_device_settings(port_: i64, index: u8) {
  wire_hal_read_device_settings_impl(port_, index)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_logic_control_0() -> *mut wire_LogicControl {
  support::new_leak_box_ptr(wire_LogicControl::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_16_list_0(len: i32) -> *mut wire_uint_16_list {
  let ans = wire_uint_16_list {
    ptr: support::new_leak_vec_ptr(Default::default(), len),
    len,
  };
  support::new_leak_box_ptr(ans)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
  let ans = wire_uint_8_list {
    ptr: support::new_leak_vec_ptr(Default::default(), len),
    len,
  };
  support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
  fn wire2api(self) -> String {
    let vec: Vec<u8> = self.wire2api();
    String::from_utf8_lossy(&vec).into_owned()
  }
}
impl Wire2Api<LogicControl> for *mut wire_LogicControl {
  fn wire2api(self) -> LogicControl {
    let wrap = unsafe { support::box_from_leak_ptr(self) };
    Wire2Api::<LogicControl>::wire2api(*wrap).into()
  }
}
impl Wire2Api<LogicControl> for wire_LogicControl {
  fn wire2api(self) -> LogicControl {
    LogicControl {
      index: self.index.wire2api(),
      scene: self.scene.wire2api(),
      values: self.values.wire2api(),
    }
  }
}

impl Wire2Api<Vec<u16>> for *mut wire_uint_16_list {
  fn wire2api(self) -> Vec<u16> {
    unsafe {
      let wrap = support::box_from_leak_ptr(self);
      support::vec_from_leak_ptr(wrap.ptr, wrap.len)
    }
  }
}
impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
  fn wire2api(self) -> Vec<u8> {
    unsafe {
      let wrap = support::box_from_leak_ptr(self);
      support::vec_from_leak_ptr(wrap.ptr, wrap.len)
    }
  }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_LogicControl {
  index: u8,
  scene: u8,
  values: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_16_list {
  ptr: *mut u16,
  len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
  ptr: *mut u8,
  len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
  fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
  fn new_with_null_ptr() -> Self {
    std::ptr::null_mut()
  }
}

impl NewWithNullPtr for wire_LogicControl {
  fn new_with_null_ptr() -> Self {
    Self {
      index: Default::default(),
      scene: Default::default(),
      values: core::ptr::null_mut(),
    }
  }
}

impl Default for wire_LogicControl {
  fn default() -> Self {
    Self::new_with_null_ptr()
  }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
  unsafe {
    let _ = support::box_from_leak_ptr(ptr);
  };
}
