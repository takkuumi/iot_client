use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_ble_get_ndid(port_: i64) {
  wire_ble_get_ndid_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_ble_at_ndrpt(
  port_: i64,
  id: *mut wire_uint_8_list,
  data: *mut wire_uint_8_list,
  retry: u8,
) {
  wire_ble_at_ndrpt_impl(port_, id, data, retry)
}

#[no_mangle]
pub extern "C" fn wire_ble_at_ndrpt_test(port_: i64) {
  wire_ble_at_ndrpt_test_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_ble_set_ndid(port_: i64, id: *mut wire_uint_8_list) {
  wire_ble_set_ndid_impl(port_, id)
}

#[no_mangle]
pub extern "C" fn wire_ble_set_mode(port_: i64, mode: u8) {
  wire_ble_set_mode_impl(port_, mode)
}

#[no_mangle]
pub extern "C" fn wire_ble_ndreset(port_: i64) {
  wire_ble_ndreset_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_ble_restore(port_: i64) {
  wire_ble_restore_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_ble_reboot(port_: i64) {
  wire_ble_reboot_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_hal_new_control(
  port_: i64,
  id: *mut wire_uint_8_list,
  retry: u8,
  index: u8,
  scene: u8,
  com_in: *mut wire_Com,
  com_out: *mut wire_Com,
) {
  wire_hal_new_control_impl(port_, id, retry, index, scene, com_in, com_out)
}

#[no_mangle]
pub extern "C" fn wire_hal_read_logic_control(
  port_: i64,
  id: *mut wire_uint_8_list,
  retry: u8,
  index: u8,
) {
  wire_hal_read_logic_control_impl(port_, id, retry, index)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_com_0() -> *mut wire_Com {
  support::new_leak_box_ptr(wire_Com::new_with_null_ptr())
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
impl Wire2Api<Com> for *mut wire_Com {
  fn wire2api(self) -> Com {
    let wrap = unsafe { support::box_from_leak_ptr(self) };
    Wire2Api::<Com>::wire2api(*wrap).into()
  }
}
impl Wire2Api<Com> for wire_Com {
  fn wire2api(self) -> Com {
    Com(self.field0.wire2api())
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
pub struct wire_Com {
  field0: u32,
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

impl NewWithNullPtr for wire_Com {
  fn new_with_null_ptr() -> Self {
    Self {
      field0: Default::default(),
    }
  }
}

impl Default for wire_Com {
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
