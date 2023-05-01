use crate::hal;

use super::{ble::at_command, serial::SerialResponse};

pub fn ble_get_ndid() -> SerialResponse {
  at_command::get_ndid()
}

pub fn ble_at_ndrpt(id: String, data: String, retry: u8) -> SerialResponse {
  at_command::at_ndrpt(&id, data.as_bytes(), retry)
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

pub fn hal_new_control(
  id: String,
  retry: u8,
  index: u8,
  scene: u8,
  com_in: hal::Com,
  com_out: hal::Com,
) -> SerialResponse {
  let logic_control = hal::LogicControl {
    index,
    scene,
    com_in,
    com_out,
  };

  let data = logic_control.bytes();
  at_command::at_ndrpt(&id, &data, retry)
}

pub fn hal_read_logic_control(id: String, retry: u8, index: u8) -> Option<hal::LogicControl> {
  None
}
