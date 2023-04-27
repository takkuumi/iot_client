use super::ble::{at_command, SerialResponse};

pub fn ble__get_ndid() -> SerialResponse {
  at_command::get_ndid()
}

pub fn ble__at_ndrpt(id: String, data: String, retry: u8) -> SerialResponse {
  at_command::at_ndrpt(&id, data.as_bytes(), retry)
}

pub fn ble__at_ndrpt_test() -> SerialResponse {
  at_command::at_ndrpt_test()
}

pub fn ble__set_ndid(id: String) -> SerialResponse {
  at_command::set_ndid(&id)
}

pub fn ble__set_mode(mode: u8) -> SerialResponse {
  at_command::set_mode(mode)
}

pub fn ble__ndreset() -> SerialResponse {
  at_command::ndreset()
}

pub fn ble__restore() -> SerialResponse {
  at_command::restore()
}
pub fn ble__reboot() -> SerialResponse {
  at_command::reboot()
}
