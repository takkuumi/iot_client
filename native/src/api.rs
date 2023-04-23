use super::ble::{at_command, SerialResponse};

pub fn get_ndid() -> SerialResponse {
  at_command::get_ndid()
}

pub fn at_ndrpt(id: String, data: String, retry: u8) -> SerialResponse {
  at_command::at_ndrpt(&id, data.as_bytes(), retry)
}

pub fn at_ndrpt_test() -> SerialResponse {
  at_command::at_ndrpt_test()
}

pub fn set_ndid(id: String) -> SerialResponse {
  at_command::set_ndid(&id)
}

pub fn set_mode(mode: u8) -> SerialResponse {
  at_command::set_mode(mode)
}

pub fn ndreset() -> SerialResponse {
  at_command::ndreset()
}

pub fn restore() -> SerialResponse {
  at_command::restore()
}
pub fn reboot() -> SerialResponse {
  at_command::reboot()
}

pub fn print_a() -> String {
  "Hello World".to_string()
}
