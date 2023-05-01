pub mod at_command;
mod crc16;

use super::serial::{send_serialport, SerialResponse};
use crc16::crc_16;
use regex::Regex;
use rmodbus::{client::ModbusRequest, server::ModbusFrame, ModbusProto};
use std::ops::Deref;

const BITS_END: &[u8; 2] = b"\r\n";

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
    let bytes = self.deref();
    let len = bytes.len();
    if len <= 4 {
      return false;
    }
    if !bytes.starts_with(BITS_END) && !bytes.ends_with(BITS_END) {
      return false;
    }

    let seq_data = b"+DATA=";
    let rang_s = 2;
    let rang_e = rang_s + seq_data.len();
    let sub = &bytes[rang_s..rang_e];
    eprintln!("sub: {:?}", String::from_utf8_lossy(sub));
    let seq_data_res = sub.eq(seq_data);
    if !seq_data_res {
      return false;
    }

    let id_reg = Regex::new(r"^\d{4}$").unwrap();

    let rang_s = rang_e;
    let rang_e = rang_s + 4;
    let sub = &bytes[rang_s..rang_e];
    eprintln!("sub: {:?}", String::from_utf8_lossy(sub));
    if !id_reg.is_match(&String::from_utf8_lossy(sub)) {
      return false;
    }

    let rang_s = rang_e;
    let rang_e = rang_s + 1;
    let sub = &bytes[rang_s..rang_e];
    eprintln!("sub: {:?}", String::from_utf8_lossy(sub));
    if !sub.eq(b",") {
      return false;
    }

    let rang_s = rang_e;
    let rang_e = rang_s + 4;
    let sub = &bytes[rang_s..rang_e];
    eprintln!("sub: {:?}", String::from_utf8_lossy(sub));
    if !id_reg.is_match(&String::from_utf8_lossy(sub)) {
      return false;
    }

    let rang_s = rang_e;
    let rang_e = rang_s + 1;
    let sub = &bytes[rang_s..rang_e];
    eprintln!("sub: {:?}", String::from_utf8_lossy(sub));
    if !sub.eq(b",") {
      return false;
    }

    let Some(index) = bytes.iter().rposition(|x| x == &b',') else {
      return false;
    };

    if index < rang_e {
      return false;
    }

    let count_reg = Regex::new(r"^\d+$").unwrap();

    let rang_s = rang_e;
    let rang_e = index;
    let sub = &bytes[rang_s..rang_e];
    let text = String::from_utf8_lossy(sub);
    eprintln!("sub: {:?}", text);
    if !count_reg.is_match(&text) {
      return false;
    }

    eprintln!("captures: {:?}", count_reg.captures(&text));
    let Some(count) =  count_reg.captures(&text) else {
      return false;
    };
    let Some(count) = count
      .get(0)
      .and_then(|v| {
        eprintln!("match: {:?}", v.as_str());
        v.as_str().parse::<usize>().ok()
      }) else {
        return false;
      };

    eprintln!("count: {:?}", count);

    if count < 10 {
      return false;
    }

    // let rang_s = rang_e + 2;
    // let rang_e = rang_s + count - 1;
    // let sub = &bytes[rang_s..rang_e];
    // let text = String::from_utf8_lossy(sub);
    // eprintln!("sub: {:?}", text);

    true
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

  pub fn parse_u16(&self, unit_id: u8, tr_id: u16) -> Option<Vec<u16>> {
    if !self.validate() {
      return None;
    }

    let index = self.get_index().unwrap();
    let rang_s = index + 2;
    let rang_e = self.deref().len() - 2;
    let sub = &self.deref()[rang_s..rang_e];

    let mut mreq = ModbusRequest::new(1, ModbusProto::TcpUdp);
    mreq.tr_id = 2;

    let text = String::from_utf8_lossy(sub);
    eprintln!("sub: {:?}", text);

    let buf = hex::decode(text.as_ref()).unwrap();
    eprintln!("buf: {:?}", buf);

    let mut resp = Vec::<u8>::new();
    resp.extend_from_slice(&[0, 2, 0, 0, 0, 14]);
    resp.extend_from_slice(&buf);

    let a = hex::encode(&resp);
    eprintln!("resp: {:?}", a);

    let v = hex::decode(a).unwrap();
    let mut result = Vec::new();
    if let Err(e) = mreq.parse_u16(&v, &mut result) {
      eprintln!("parse_string error: {:?}", e);
      return None;
    }

    Some(result)
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

  use rmodbus::{client::ModbusRequest, guess_response_frame_len, ModbusProto};

  #[test]
  fn parse_works() {
    let bytes = [
      13, 10, 43, 68, 65, 84, 65, 61, 48, 48, 48, 49, 44, 48, 48, 48, 51, 44, 49, 57, 44, 200, 48,
      49, 48, 51, 48, 52, 48, 48, 48, 49, 48, 48, 48, 48, 65, 66, 70, 51, 13, 10,
    ];

    eprintln!("{}", String::from_utf8_lossy(&bytes));
    let pa = BytesParse::new(&bytes);
    let res = pa.validate();
    eprintln!("{:?}", res);
    if res {
      let res = pa.parse_u16(1, 2);
      eprintln!("{:?}", res);
    }
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
    stream.write(&request).unwrap();

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
    stream.write(&request).unwrap();
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
