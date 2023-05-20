pub mod at_command;
mod crc16;

use super::serial::{
  send_serialport_once,
  send_serialport_until,
  DataType,
  ReadStat,
  SerialResponse,
};
use regex::bytes::Regex;
use rmodbus::{client::ModbusRequest, ModbusProto};
use std::ops::Deref;

#[derive(Debug, PartialEq)]
pub struct BytesParse<'s>(pub &'s [u8]);

impl<'s> Deref for BytesParse<'s> {
  type Target = [u8];

  fn deref(&self) -> &Self::Target {
    self.0
  }
}

impl<'s> BytesParse<'s> {
  pub fn new(bytes: &'s [u8]) -> Self {
    Self(bytes)
  }

  pub fn validate(&self) -> bool {
    let re: Regex = Regex::new(r"\+DATA=(?P<a>\d+),(?P<length>\d+),(?P<data>\S+)").unwrap();

    if let Some(caps) = re.captures(self.deref()) {
      let length = caps.name("length");
      let data = caps.name("data");

      if let (Some(length), Some(data)) = (length, data) {
        let length = String::from_utf8_lossy(length.as_bytes())
          .parse::<usize>()
          .unwrap();
        return data.len() == length;
      }
    }

    false
  }

  pub fn get_index(&self) -> Option<usize> {
    self.deref().iter().rposition(|x| x == &b',')
  }

  pub fn parse_string(&self, unit_id: u8, tr_id: u16) -> Option<String> {
    let state = self.validate();
    if !state {
      return None;
    }

    let index = self.get_index().unwrap();
    let rang_s = index + 2;
    let rang_e = self.deref().len() - 2;
    let sub = &self.deref()[rang_s..rang_e];
    eprintln!("sub: {:?}", String::from_utf8_lossy(sub));

    let mut mreq = ModbusRequest::new(unit_id, ModbusProto::Rtu);
    mreq.tr_id = tr_id;

    let mut result = String::new();
    if let Err(e) = mreq.parse_string(self.deref(), &mut result) {
      eprintln!("parse_string error: {:?}", e);
      return None;
    }

    Some(result)
  }

  pub fn parse_u16(&self) -> Option<Vec<u16>> {
    if !self.validate() {
      return None;
    }

    let re: Regex = Regex::new(r"\+DATA=\d+,\d+,(?P<data>\S+)").unwrap();
    if let Some(m) = re.captures(self.deref()).and_then(|caps| caps.name("data")) {
      // +DATA=0,014,0103020000B844
      let re2: Regex =
        Regex::new(r"(?P<id>\S{2})(?P<fc>\S{2})(?P<count>\S{2})(?P<content>\S+)").unwrap();

      if let Some(caps) = re2.captures(m.as_bytes()) {
        let id = caps.name("id").unwrap();
        let fc = caps.name("fc").unwrap();
        let count = caps.name("count").unwrap();
        let content = caps.name("content").unwrap();

        let id = String::from_utf8_lossy(id.as_bytes())
          .parse::<u8>()
          .unwrap();
        let fc = String::from_utf8_lossy(fc.as_bytes())
          .parse::<u8>()
          .unwrap();
        let count = String::from_utf8_lossy(count.as_bytes())
          .parse::<u16>()
          .unwrap();

        eprintln!("id: {}, fc: {}, count: {}", id, fc, count);

        let content_bytes = content.as_bytes();

        eprintln!("content_bytes len : {}", content_bytes.len());
        let content = String::from_utf8_lossy(&content_bytes[..(content_bytes.len() - 4)]);
        let res = hex::decode(content.as_ref()).unwrap();

        let chunks = res.chunks(2);

        let mut result = Vec::new();
        for chunk in chunks {
          let mut buf = [0u8; 2];
          buf.copy_from_slice(chunk);
          let val = u16::from_be_bytes(buf);
          result.push(val);
        }

        return Some(result);
      }
    };

    None
  }

  pub fn parse_bool(&self) -> Option<Vec<u8>> {
    if !self.validate() {
      return None;
    }

    let re: Regex = Regex::new(r"\+DATA=\d+,\d+,(?P<data>\S+)").unwrap();
    if let Some(m) = re.captures(self.deref()).and_then(|caps| caps.name("data")) {
      // +DATA=0,014,0103020000B844
      let re2: Regex =
        Regex::new(r"(?P<id>\S{2})(?P<fc>\S{2})(?P<count>\S{2})(?P<content>\S+)").unwrap();

      if let Some(caps) = re2.captures(m.as_bytes()) {
        let id = caps.name("id").unwrap();
        let fc = caps.name("fc").unwrap();
        let count = caps.name("count").unwrap();
        let content = caps.name("content").unwrap();

        let id = String::from_utf8_lossy(id.as_bytes())
          .parse::<u8>()
          .unwrap();
        let fc = String::from_utf8_lossy(fc.as_bytes())
          .parse::<u8>()
          .unwrap();
        let count = String::from_utf8_lossy(count.as_bytes())
          .parse::<u16>()
          .unwrap();

        eprintln!("id: {}, fc: {}, count: {}", id, fc, count);

        let content_bytes = content.as_bytes();

        eprintln!("content_bytes len : {}", content_bytes.len());
        let content = String::from_utf8_lossy(&content_bytes[..(content_bytes.len() - 4)]);
        let res = hex::decode(content.as_ref()).unwrap();

        let mut result = Vec::new();
        for item in res {
          let bits_str = format!("{:08b}", item);

          let other = bits_str
            .chars()
            .rev()
            .map(|a| a.to_string().parse::<u8>().unwrap())
            .collect::<Vec<u8>>();
          result.extend_from_slice(&other);
        }

        return Some(result);
      }
    };

    None
  }

  pub fn get_from(&self) -> Option<String> {
    None
  }

  pub fn get_target(&self) -> Option<String> {
    None
  }

  pub fn get_value(&self) -> Option<(u8, u8, u16, Vec<u16>, u16)> {
    None
  }
}

#[cfg(test)]
mod test {
  use super::BytesParse;
  use std::{
    io::{Read, Write},
    net::TcpStream,
    time::Duration,
  };

  use regex::bytes::Regex;
  use rmodbus::{client::ModbusRequest, guess_response_frame_len, ModbusProto};

  #[test]
  fn parse_works() {
    let bytes = "\r\n+DATA=0,170,01035032313433363500370000000000000000000042414443464500470000000000000000000080020001000200C80064800100010002019000C880020001000200C8006480020001000107D003E8800200012EF7\r\n".as_bytes();

    eprintln!("{}", String::from_utf8_lossy(bytes));
    let pa = BytesParse::new(bytes);
    let res = pa.validate();
    eprintln!("= {}", res);
    if res {
      let res = pa.parse_u16();
      eprintln!("{:?}", res);
    }
  }

  #[test]
  fn parse_bool_works() {
    let bytes = "\r\n+DATA=0,016,01010301000318E\r\n".as_bytes();

    eprintln!("{}", String::from_utf8_lossy(bytes));
    let pa = BytesParse::new(bytes);
    let res = pa.validate();
    eprintln!("= {}", res);
    if res {
      let res = pa.parse_bool();
      eprintln!("{:?}", res);
    }
  }

  #[test]
  fn match_works() {
    let text = "\r\n+DATA=0,170,01035032313433363500370000000000000000000042414443464500470000000000000000000080020001000200C80064800100010002019000C880020001000200C8006480020001000107D003E8800200012EF7\r\n";

    let re: Regex = Regex::new(r"\+DATA=(?P<a>\d+),(?P<length>\d+),(?P<data>\S+)").unwrap();

    let res = re.is_match(text.as_bytes());

    eprintln!("res: {}", res);

    let caps = re.captures(text.as_bytes()).unwrap();
    let res1 = caps.name("length");
    eprintln!("res1: {:?}", res1);

    let res2 = caps.name("data");
    eprintln!("res1: {:?}", res2);
  }

  #[test]
  fn t() {
    let timeout = Duration::from_secs(1);

    // open TCP connection
    let mut stream = TcpStream::connect("192.168.10.160:5002").unwrap();
    stream.set_read_timeout(Some(timeout)).unwrap();
    stream.set_write_timeout(Some(timeout)).unwrap();

    // create request object
    let mut mreq = ModbusRequest::new(1, ModbusProto::TcpUdp);
    mreq.tr_id = 2; // just for test, default tr_id is 1

    // set 2 coils
    let mut request = Vec::new();
    mreq
      .generate_set_coils_bulk(512, &[true, true], &mut request)
      .unwrap();

    // write request to stream
    stream.write_all(&request).unwrap();

    // read first 6 bytes of response frame
    let mut buf = [0u8; 6];
    stream.read_exact(&mut buf).unwrap();
    let mut response = Vec::new();
    response.extend_from_slice(&buf);
    let len = guess_response_frame_len(&buf, ModbusProto::TcpUdp).unwrap();
    // read rest of response frame
    if len > 6 {
      let mut rest = vec![0u8; (len - 6) as usize];
      stream.read_exact(&mut rest).unwrap();
      response.extend(rest);
    }
    // check if frame has no Modbus error inside
    mreq.parse_ok(&response).unwrap();

    // get coil values back
    mreq.generate_get_coils(0, 2, &mut request).unwrap();
    stream.write_all(&request).unwrap();
    let mut buf = [0u8; 6];
    stream.read_exact(&mut buf).unwrap();
    let mut response = Vec::new();
    response.extend_from_slice(&buf);
    let len = guess_response_frame_len(&buf, ModbusProto::TcpUdp).unwrap();
    if len > 6 {
      let mut rest = vec![0u8; (len - 6) as usize];
      stream.read_exact(&mut rest).unwrap();
      response.extend(rest);
    }
    let mut data = Vec::new();
    // check if frame has no Modbus error inside and parse response bools into data vec
    let a = hex::encode(&response);
    eprintln!("{:?}", a);
    mreq.parse_bool(&response, &mut data).unwrap();
    for i in 0..data.len() {
      println!("{} {}", i, data[i]);
    }
  }
}
// 00020000000701030400010000
// 0001000000050103020001
// 00020000000401010100
