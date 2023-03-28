use anyhow::Result;

pub fn init_tty_swk0(millis: u64) -> Result<()> {
  super::ble::serial::init_tty_swk0(millis)
}
pub fn get_ndid() -> Result<Vec<u8>> {
  super::ble::at_command::get_ndid()
}

pub fn at_ndrpt(id: String, data: String) -> Result<Vec<u8>> {
  super::ble::at_command::at_ndrpt(&id, data.as_bytes())
}

pub fn at_ndrpt2(id: String, data: String) -> Result<Vec<u8>> {
  super::ble::at_command::at_ndrpt2(&id, data.as_bytes())
}

pub fn at_ndrpt_test() -> Result<Vec<u8>> {
  super::ble::at_command::at_ndrpt_test()
}

pub fn set_ndid(id: String) -> Result<Vec<u8>> {
  super::ble::at_command::set_ndid(&id)
}

pub fn set_mode(mode: u8) -> Result<Vec<u8>> {
  super::ble::at_command::set_mode(mode)
}

pub fn ndreset() -> Result<Vec<u8>> {
  super::ble::at_command::ndreset()
}

pub fn restore() -> Result<Vec<u8>> {
  super::ble::at_command::restore()
}
pub fn reboot() -> Result<Vec<u8>> {
  super::ble::at_command::reboot()
}

pub fn print_a() -> String {
  "Hello World".to_string()
}
