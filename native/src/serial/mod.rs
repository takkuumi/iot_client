use serialport::{ClearBuffer, DataBits, FlowControl, StopBits};

// serialport::new("/dev/tty.usbserial-1430", 115200)
// serialport::new("/dev/tty.usbserial-1410", 115200)
// ttySWK0

const BITS_END: &[u8; 2] = b"\r\n";

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

// tty.usbserial-1410
// ttySWK0

fn open_tty_swk0(millis: u64) -> Result<Box<dyn serialport::SerialPort>, serialport::Error> {
  serialport::new("/dev/ttySWK0", 115_200)
    .data_bits(DataBits::Eight)
    .stop_bits(StopBits::One)
    .flow_control(FlowControl::Software)
    .timeout(core::time::Duration::from_millis(millis))
    .open()
}

fn read_serialport(port: &mut Box<dyn serialport::SerialPort>) -> SerialResponse {
  let mut response = SerialResponse::default();
  let mut retry: u8 = 0;
  let mut buffer = Vec::<u8>::with_capacity(80);
  loop {
    if (buffer.len() > 2) && buffer.ends_with(BITS_END) {
      response.set_ok(&buffer);
      break;
    }

    let mut resp_buf = [0_u8; 10];
    let res = port.read(&mut resp_buf);
    match res {
      Err(ref e) => {
        eprintln!("{:?}", e);
        if retry > 5 {
          response.state = ResponseState::ReadResponseError;
          break;
        }
        retry += 1;
        std::thread::sleep(core::time::Duration::from_millis(u64::from(retry) * 30));
        continue;
      }
      Ok(size) => {
        if size == 0 {
          continue;
        }

        eprintln!("{}", String::from_utf8_lossy(&resp_buf));
        retry = 0;
        buffer.extend_from_slice(&resp_buf[..size]);
      }
    }
  }

  response
}

#[must_use]
pub fn send_serialport(data: &[u8]) -> SerialResponse {
  let mut response = SerialResponse::default();

  let tty_device = open_tty_swk0(500);
  if tty_device.is_err() {
    response.state = ResponseState::FailedOpenDevice;
    return response;
  }
  let mut port = tty_device.unwrap();
  let _ = port.clear(ClearBuffer::Input);
  let _ = port.clear_break();
  let mut retry: u8 = 0;
  'outer: loop {
    if retry > 3 {
      response.state = ResponseState::MaxSendRetry;
      return response;
    }

    if retry != 0 {
      eprintln!("retry:{retry}");
      let _ = port.clear(ClearBuffer::Input);
      std::thread::sleep(core::time::Duration::from_millis(u64::from(retry) * 100));
    }

    let chunks = data.chunks_exact(10);
    let rem = chunks.remainder();
    for chunk in chunks {
      eprintln!("chunk:{:?}", chunk);
      eprintln!("chunk data {}", String::from_utf8_lossy(chunk));
      let w_res = port.write(chunk);
      // let _ = port.flush();
      if w_res.is_err() {
        retry += 1;
        continue 'outer;
      }
    }

    let mut end: Vec<u8> = Vec::new();
    if !rem.is_empty() {
      end.extend_from_slice(rem);
    }
    end.extend_from_slice(BITS_END);

    eprintln!("remainder:{:?}", &end);
    eprintln!("remainder data {}", String::from_utf8_lossy(&end));

    let w_res = port.write(&end);
    let _ = port.flush();

    if w_res.is_err() {
      retry += 1;
      continue 'outer;
    }

    let mut buf = [0_u8; 15];
    let bt_res = port.read(&mut buf);

    if bt_res.is_err() {
      retry += 1;
      continue 'outer;
    }
    if buf.starts_with(b"\r\nE") {
      retry += 1;
      let err_msg = String::from_utf8_lossy(&buf);
      eprintln!("蓝牙发送失败({retry}),错误码:{err_msg}");
      continue 'outer;
    }
    // buffer.extend_from_slice(&buf[..size]);
    break 'outer;
  }

  read_serialport(&mut port)
}

fn read_serialport_until(
  port: &mut Box<dyn serialport::SerialPort>,
  max_try: u16,
  needle: &[u8],
) -> SerialResponse {
  let mut response = SerialResponse::default();
  let mut buffer = Vec::<u8>::with_capacity(80);

  let mut retry: u16 = 0;
  loop {
    if (buffer.len() > 2) && buffer.ends_with(needle) {
      response.set_ok(&buffer);
      break;
    }

    if retry >= max_try {
      response.set_err(ResponseState::MaxRetry);
      break;
    }
    let mut resp_buf = [0_u8; 6];
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
pub fn send_serialport_until(data: &[u8], max_try: u16, needle: &[u8]) -> SerialResponse {
  let mut response = SerialResponse::default();

  let tty_device = open_tty_swk0(500);
  if tty_device.is_err() {
    response.state = ResponseState::FailedOpenDevice;
    return response;
  }
  let mut port = tty_device.unwrap();

  let data = wrap_send_data(data);
  let _ = port.write(&data);

  read_serialport_until(&mut port, max_try, needle)
}
