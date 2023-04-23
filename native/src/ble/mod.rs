pub mod at_command;
mod crc16;
mod serial;

use crc16::crc_16;
use serial::send_serialport;

#[derive(Debug, PartialEq)]
pub enum ResponseState {
  Ok,
  FailedOpenDevice,
  Timeout,
  Unknown,
  MaxRetry,
  MaxSendRetry,
  ReadResponseError,
}

impl Default for ResponseState {
  fn default() -> Self {
    Self::Unknown
  }
}
#[derive(Debug, Default)]
pub struct SerialResponse {
  pub state: ResponseState,
  pub data: Option<Vec<u8>>,
}

impl SerialResponse {
  pub fn set_ok(&mut self, buf: &[u8]) {
    self.state = ResponseState::Ok;
    self.data = Some(buf.to_vec());
  }

  #[must_use]
  pub fn new_err() -> Self {
    Self {
      state: ResponseState::MaxRetry,
      data: None,
    }
  }

  #[must_use]
  pub fn is_ok(&self) -> bool {
    self.state == ResponseState::Ok
  }

  #[must_use]
  pub fn is_err(&self) -> bool {
    !self.is_ok()
  }
}
