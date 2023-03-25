pub mod at_command;
pub mod crc16;
// pub mod hex;
pub mod serial;

pub struct SerialResponse<'s>(&'s [u8]);

impl<'s> SerialResponse<'s> {
  pub fn to_buffer(&self) -> Vec<u8> {
    self.0.to_vec()
  }
}

impl<'s> ToString for SerialResponse<'s> {
  fn to_string(&self) -> String {
    String::from_utf8_lossy(self.0).to_string()
  }
}
