use regex::bytes::Regex;
use serialport::{DataBits, FlowControl, StopBits, TTYPort};

use once_cell::sync::Lazy;
use std::{
  io::{Read, Write},
  sync::Mutex,
};
// serialport::new("/dev/tty.usbserial-1430", 115200)
// serialport::new("/dev/tty.usbserial-1410", 115200)
// ttySWK0

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

  pub fn set_err(&mut self, state: ResponseState) {
    self.state = state;

    self.data = None;
  }

  pub fn is_ok(&self) -> bool {
    self.state == ResponseState::Ok
  }

  pub fn is_err(&self) -> bool {
    !self.is_ok()
  }
}

static CELL: Lazy<Mutex<TTYPort>> = Lazy::new(|| {
  let port = serialport::new("/dev/ttySWK0", 115_200)
    .data_bits(DataBits::Eight)
    .stop_bits(StopBits::One)
    .flow_control(FlowControl::None)
    .timeout(core::time::Duration::from_millis(100))
    .open_native()
    .unwrap();

  Mutex::new(port)
});

#[derive(Debug, Clone, Copy)]
pub enum DataType {
  OK,
  OkOrErr,
  Scan,
  Date,
  GATTStat,
}

#[derive(Debug, PartialEq)]
pub enum ReadStat {
  Waiting,
  Ok,
  Err,
  OkOrErr,
}

impl DataType {
  pub fn check_ok(buffer: &[u8]) -> ReadStat {
    if buffer.ends_with(b"OK\r\n") {
      return ReadStat::Ok;
    }
    ReadStat::Err
  }

  pub fn check_scan(buffer: &[u8]) -> ReadStat {
    if buffer.ends_with(b"}\r\n") {
      return ReadStat::Ok;
    }
    ReadStat::Err
  }

  pub fn check_ok_or_err(buffer: &[u8]) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);
    if resp_text.contains("OK")
      || resp_text.contains("RR")
      || resp_text.contains("OR")
      || resp_text.contains("RO")
    {
      return ReadStat::OkOrErr;
    }
    ReadStat::Err
  }

  pub fn check_data(buffer: &[u8]) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);
    if resp_text.contains("+DATA") {
      let re: Regex = Regex::new(r"\+DATA=(?P<a>\d+),(?P<length>\d+),(?P<data>\S+)").unwrap();
      if let Some(caps) = re.captures(buffer) {
        let length = caps.name("length");
        let data = caps.name("data");

        if let (Some(length), Some(data)) = (length, data) {
          let length = String::from_utf8_lossy(length.as_bytes())
            .parse::<usize>()
            .unwrap();
          if data.len() == length {
            return ReadStat::Ok;
          }
        }
      }
    }
    ReadStat::Err
  }

  pub fn check_gatt_stat(buffer: &[u8]) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);
    if resp_text.contains("+GATTSTAT") {
      let re: Regex = Regex::new(r"\+GATTSTAT=(\d+),(?P<stat>\d+)").unwrap();
      let caps = re.captures_iter(buffer);
      let stat = caps
        .last()
        .and_then(|s| s.name("stat"))
        .map(|m| String::from_utf8_lossy(m.as_bytes()));

      if let Some(stat) = stat {
        let stat = stat.parse::<u8>().unwrap();
        if stat == 3 {
          return ReadStat::Ok;
        } else if stat == 2 {
          return ReadStat::Waiting;
        }
      }
    }
    ReadStat::Err
  }
}

// tty.usbserial-1410
// ttySWK0

fn read_serialport_until(port: &mut TTYPort, read_try: u8, flag: DataType) -> SerialResponse {
  let mut response = SerialResponse::default();
  let mut buffer = Vec::<u8>::with_capacity(80);

  let mut retry: u8 = 0;
  loop {
    if buffer.len() > 2 {
      let result = match flag {
        DataType::OK => DataType::check_ok(&buffer),
        DataType::Scan => DataType::check_scan(&buffer),
        DataType::Date => DataType::check_data(&buffer),
        DataType::GATTStat => DataType::check_gatt_stat(&buffer),
        DataType::OkOrErr => DataType::check_ok_or_err(&buffer),
      };
      if result == ReadStat::Ok || result == ReadStat::OkOrErr {
        response.set_ok(&buffer);
        break;
      }
    }

    if retry >= read_try {
      response.set_err(ResponseState::MaxRetry);
      break;
    }

    let mut resp_buf = [0_u8; 4];
    if let Ok(size) = port.read(&mut resp_buf) {
      if size > 0 {
        eprintln!("{}", String::from_utf8_lossy(&resp_buf));
        buffer.extend_from_slice(&resp_buf[..size]);
      }
    } else {
      retry += 1;
    }
  }

  response
}

fn wrap_send_data(data: &[u8]) -> Vec<u8> {
  if data.ends_with(b"\r\n") {
    return data.to_vec();
  }
  let mut wrap_data = Vec::<u8>::with_capacity(data.len() + 2);
  wrap_data.extend_from_slice(data);
  wrap_data.extend_from_slice(b"\r\n");
  wrap_data
}

#[must_use]
pub fn send_serialport_until(data: &[u8], read_try: u8, flag: DataType) -> SerialResponse {
  let mut response = SerialResponse::default();

  let tty_device = CELL.try_lock();

  // let tty_device = open_tty_swk0(500);
  if tty_device.is_err() {
    response.state = ResponseState::FailedOpenDevice;
    return response;
  }
  let mut port = tty_device.unwrap();

  let data = wrap_send_data(data);
  let _ = port.write(&data);

  read_serialport_until(&mut port, read_try, flag)
}

#[cfg(test)]
mod test {
  use std::eprintln;

  use super::DataType;

  #[test]
  fn it_works() {
    let buffer = r#"
    OK

    +GATTSTAT=0,2


    +GATTSTAT=0,3
    "#;

    let res = DataType::check_gatt_stat(buffer.as_bytes());
    eprintln!("{:?}", res);
  }
}
