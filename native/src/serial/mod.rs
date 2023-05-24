use chrono::Utc;
use regex::bytes::Regex;
use serialport::{DataBits, FlowControl, SerialPort, StopBits, TTYPort};

use std::{
  io::{Read, Write},
  sync::{Arc, Mutex},
};
// serialport::new("/dev/tty.usbserial-1430", 115200)
// serialport::new("/dev/tty.usbserial-1410", 115200)
// ttySWK0

#[cfg(target_os = "macos")]
static DEVICE_PATH: &str = "/dev/tty.usbserial-1410";
#[cfg(target_os = "android")]
static DEVICE_PATH: &str = "/dev/ttySWK0";

#[derive(Debug, PartialEq)]
pub enum ResponseState {
  Ok,
  Error(ErrorKind),
}

impl Default for ResponseState {
  fn default() -> Self {
    Self::Ok
  }
}

#[derive(Debug, PartialEq)]
pub enum ErrorKind {
  FailedOpenDevice,
  Timeout,
  Unknown,
  FailedReadData,
  ReadResponseError,
  FailedWrite,
  DeviceBusy,
  ClearBufferError,
  FlushBufferError,
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

  pub fn set_err(&mut self, err: ErrorKind) {
    self.state = ResponseState::Error(err);
  }

  pub fn is_ok(&self) -> bool {
    self.state == ResponseState::Ok
  }

  pub fn is_err(&self) -> bool {
    !self.is_ok()
  }
}

// fn open_device() -> Result<Box<dyn SerialPort>, serialport::Error> {
//   serialport::new("/dev/ttySWK0", 115_200)
//     .data_bits(DataBits::Eight)
//     .stop_bits(StopBits::One)
//     .flow_control(FlowControl::None)
//     .timeout(core::time::Duration::from_millis(100))
//     .open()
// }

lazy_static::lazy_static! {
  static ref CHINFO_REGEX: Regex = Regex::new(r"\+CHINFO=9,\d,\d,(\S{12})").unwrap();
  static ref DATA_REGEX: Regex = Regex::new(r"\S+=(?P<a>\d+),(?P<length>\d+),(?P<data>\S+)").unwrap();
  static ref GATTSTAT_REGEX: Regex = Regex::new(r"\+GATTSTAT=(\d+),(?P<stat>\d+)").unwrap();

  static ref LOCK_STAT:Mutex<bool> = Mutex::new(false);
  static ref TTYPORT_DEVICE: Arc<Mutex<TTYPort>> =  {
    let mut port = serialport::new(DEVICE_PATH, 115_200)
      .data_bits(DataBits::Eight)
      .stop_bits(StopBits::One)
      .flow_control(FlowControl::Software)
      .timeout(core::time::Duration::from_millis(32))
      .open_native()
      .unwrap();

   let _ =  port.set_exclusive(false);

   Arc::new(Mutex::new(port))
  };
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum DataType {
  OkOrErr,
  Scan,
  Date,
  GATTStat,
  Chinfo,
}

#[derive(Debug, PartialEq)]
pub enum ReadStat {
  Waiting,
  Ok,
  Err,
}

impl DataType {
  pub fn check_ok(buffer: &[u8]) -> ReadStat {
    if buffer.ends_with(b"OK\r\n") {
      return ReadStat::Ok;
    }
    ReadStat::Err
  }

  pub fn check_scan(buffer: &[u8]) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);

    if resp_text.contains("ERROR")
      || resp_text.contains("ER")
      || resp_text.contains("RR")
      || resp_text.contains("RO")
      || resp_text.contains("OR")
    {
      return ReadStat::Err;
    }
    if buffer.ends_with(b"}\r\n") {
      return ReadStat::Ok;
    }
    ReadStat::Waiting
  }

  pub fn check_ok_or_err(buffer: &[u8]) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);
    if resp_text.contains("OK") {
      return ReadStat::Ok;
    } else if resp_text.contains("ERROR")
      || resp_text.contains("ER")
      || resp_text.contains("RR")
      || resp_text.contains("RO")
      || resp_text.contains("OR")
    {
      return ReadStat::Err;
    }

    ReadStat::Waiting
  }

  pub fn check_data(buffer: &[u8]) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);

    if resp_text.contains("ERROR")
      || resp_text.contains("ER")
      || resp_text.contains("RR")
      || resp_text.contains("RO")
      || resp_text.contains("OR")
    {
      return ReadStat::Err;
    }

    if let Some(caps) = DATA_REGEX.captures(buffer) {
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

    ReadStat::Waiting
  }

  pub fn check_gatt_stat_with(buffer: &[u8], state: u8) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);

    if resp_text.contains("+GATTSTAT") {
      let caps = GATTSTAT_REGEX.captures_iter(buffer);
      let stat = caps
        .last()
        .and_then(|s| s.name("stat"))
        .map(|m| String::from_utf8_lossy(m.as_bytes()));

      tracing::info!("check_gatt_stat_with: {:?}", stat);

      if let Some(stat) = stat {
        let stat = stat.parse::<u8>().unwrap();
        if stat == state {
          return ReadStat::Ok;
        }
      }
    }
    ReadStat::Err
  }

  pub fn check_gatt_stat(buffer: &[u8]) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);

    tracing::info!("check_gatt_stat: {}", resp_text);

    if resp_text.contains("ERROR")
      || resp_text.contains("ER")
      || resp_text.contains("RR")
      || resp_text.contains("RO")
      || resp_text.contains("OR")
    {
      return ReadStat::Err;
    }

    if resp_text.contains("+GATTSTAT") {
      let caps = GATTSTAT_REGEX.captures_iter(buffer);
      let stat = caps
        .last()
        .and_then(|s| s.name("stat"))
        .map(|m| String::from_utf8_lossy(m.as_bytes()));

      if let Some(stat) = stat {
        let stat = stat.parse::<u8>().unwrap();
        if stat == 3 || stat == 1 {
          return ReadStat::Ok;
        }
      }
    }
    ReadStat::Waiting
  }

  pub fn check_chinfo(buffer: &[u8]) -> ReadStat {
    let resp_text = String::from_utf8_lossy(buffer);

    if resp_text.contains("ERROR")
      || resp_text.contains("ER")
      || resp_text.contains("RR")
      || resp_text.contains("RO")
      || resp_text.contains("OR")
    {
      return ReadStat::Err;
    }

    if CHINFO_REGEX.is_match(buffer) {
      return ReadStat::Ok;
    }
    ReadStat::Waiting
  }
}

// tty.usbserial-1410
// ttySWK0

fn read_serialport_until(port: &mut TTYPort, flag: DataType) -> SerialResponse {
  let mut response = SerialResponse::default();
  let mut buffer = Vec::<u8>::with_capacity(128);

  // let start = std::time::Instant::now().elapsed().as_millis();

  // let timeout = timeout as u128;

  // let mut retry = 0;
  loop {
    let mut resp_buf = [0_u8; 128];
    if let Ok(size) = port.read(resp_buf.as_mut_slice()) {
      if size > 0 {
        buffer.extend_from_slice(&resp_buf[..size]);
      }
    }

    if buffer.len() > 2 {
      let result = match flag {
        DataType::OkOrErr => DataType::check_ok_or_err(&buffer),
        DataType::Scan => DataType::check_scan(&buffer),
        DataType::Date => DataType::check_data(&buffer),
        DataType::GATTStat => DataType::check_gatt_stat(&buffer),
        DataType::Chinfo => DataType::check_chinfo(&buffer),
      };

      if result == ReadStat::Ok {
        response.set_ok(&buffer);
        break;
      } else if result == ReadStat::Err {
        response.set_err(ErrorKind::FailedReadData);
        break;
      }
    }
    // if retry >= 100 {
    //   response.set_err(ErrorKind::Timeout);
    //   break;
    // }
    // let current = std::time::Instant::now().elapsed().as_millis();
    // if (current - start) > timeout {
    //   response.set_err(ErrorKind::Timeout);
    //   break;
    // }
    // std::thread::sleep(core::time::Duration::from_millis(10));
    // retry += 1;
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
pub fn send_serialport_once(data: &[u8], flag: DataType) -> SerialResponse {
  let mut response = SerialResponse::default();

  let arc_tty_device = TTYPORT_DEVICE.clone();
  {
    let mut port = arc_tty_device.lock().unwrap();
    if port.clear(serialport::ClearBuffer::All).is_err() {
      response.set_err(ErrorKind::ClearBufferError);
      return response;
    }

    let data = wrap_send_data(data);
    std::thread::sleep(core::time::Duration::from_millis(16));

    if port.write(&data).is_err() {
      response.set_err(ErrorKind::FailedWrite);
      return response;
    }

    std::thread::sleep(core::time::Duration::from_millis(160));

    let mut buffer = Vec::<u8>::with_capacity(244);

    loop {
      let Ok(size) = port.bytes_to_read() else {
        continue;
      };
      let mut resp_buf = [0_u8; 244];

      match port.read(&mut resp_buf) {
        Ok(size) => {
          if size > 0 {
            buffer.extend_from_slice(&resp_buf[..size]);
          } else {
            response.set_ok(&buffer);
            break;
          }
        }
        Err(e) => {
          response.set_err(ErrorKind::Timeout);
          break;
        }
      };

      let result = match flag {
        DataType::OkOrErr => DataType::check_ok_or_err(&buffer),
        DataType::Scan => DataType::check_scan(&buffer),
        DataType::Date => DataType::check_data(&buffer),
        DataType::GATTStat => DataType::check_gatt_stat(&buffer),
        DataType::Chinfo => DataType::check_chinfo(&buffer),
      };

      if result == ReadStat::Ok {
        response.set_ok(&buffer);
        break;
      } else if result == ReadStat::Err {
        response.set_err(ErrorKind::FailedReadData);
        break;
      }
    }

    drop(port);
  }
  response
}

#[must_use]
pub fn send_serialport_until(data: &[u8], flag: DataType) -> SerialResponse {
  let mut response = SerialResponse::default();

  let arc_tty_device = TTYPORT_DEVICE.clone();
  {
    let mut port = arc_tty_device.lock().unwrap();

    if port.clear(serialport::ClearBuffer::All).is_err() {
      response.set_err(ErrorKind::ClearBufferError);
      return response;
    }

    let data = wrap_send_data(data);
    std::thread::sleep(core::time::Duration::from_millis(16));

    if port.write(&data).is_err() {
      response.set_err(ErrorKind::FailedWrite);
      return response;
    }

    if port.flush().is_err() {
      response.set_err(ErrorKind::FlushBufferError);
      return response;
    }
    std::thread::sleep(core::time::Duration::from_millis(160));

    let mut buffer = Vec::<u8>::with_capacity(244);

    let mut waiting_count = 0;
    loop {
      let Ok(size) = port.bytes_to_read() else {
        continue;
      };
      let mut resp_buf = [0_u8; 244];

      match port.read(&mut resp_buf) {
        Ok(size) => {
          if size > 0 {
            buffer.extend_from_slice(&resp_buf[..size]);
          } else {
            response.set_ok(&buffer);
            break;
          }
        }
        Err(e) => {
          tracing::error!("Error kind: {}, msg: {}", e.kind(), e.to_string());
        }
      };

      let result = match flag {
        DataType::OkOrErr => DataType::check_ok_or_err(&buffer),
        DataType::Scan => DataType::check_scan(&buffer),
        DataType::Date => DataType::check_data(&buffer),
        DataType::GATTStat => DataType::check_gatt_stat(&buffer),
        DataType::Chinfo => DataType::check_chinfo(&buffer),
      };

      if result == ReadStat::Ok {
        response.set_ok(&buffer);
        break;
      } else if result == ReadStat::Err {
        response.set_err(ErrorKind::FailedReadData);
        break;
      }

      if flag == DataType::Date && result == ReadStat::Waiting && waiting_count >= 200 {
        response.set_err(ErrorKind::Timeout);
        break;
      }

      if result == ReadStat::Waiting {
        std::thread::sleep(core::time::Duration::from_millis(16));
      }

      waiting_count += 1;
    }

    drop(port);
  }
  response
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
