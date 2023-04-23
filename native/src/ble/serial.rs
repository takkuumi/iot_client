use super::{ResponseState, SerialResponse};
use anyhow::{Context, Result};
use serialport::{ClearBuffer, DataBits, FlowControl, StopBits};

// serialport::new("/dev/tty.usbserial-1430", 115200)
// serialport::new("/dev/tty.usbserial-1410", 115200)
// ttySWK0

const BITS_END: &[u8; 2] = b"\r\n";

fn open_tty_swk0(millis: u64) -> Result<Box<dyn serialport::SerialPort>> {
  serialport::new("/dev/ttySWK0", 115_200)
    .data_bits(DataBits::Eight)
    .stop_bits(StopBits::One)
    .flow_control(FlowControl::None)
    .timeout(core::time::Duration::from_millis(millis))
    .open()
    .context("failed to open device!")
}

fn read_serialport(port: &mut Box<dyn serialport::SerialPort>) -> SerialResponse {
  let mut response = SerialResponse::default();
  let mut count: u8 = 0;
  let mut buffer = Vec::<u8>::with_capacity(80);
  loop {
    if buffer.len() > 2 && buffer.ends_with(BITS_END) {
      break;
    }

    let mut resp_buf = [0_u8; 10];
    let res = port.read(&mut resp_buf);
    match res {
      Err(ref e) => {
        if count > 10 {
          response.state = ResponseState::ReadResponseError;
          return response;
        }
        count += 1;
        std::thread::sleep(core::time::Duration::from_millis(u64::from(count) * 30));
        continue;
      }
      Ok(size) => {
        if size == 0 {
          break;
        }
        count = 0;
        buffer.extend_from_slice(&resp_buf[..size]);
      }
    }
  }
  response.set_ok(&buffer);
  response
}

pub fn send_serialport(data: &[u8]) -> SerialResponse {
  let mut response = SerialResponse::default();

  let tty_device = open_tty_swk0(500);
  if tty_device.is_err() {
    response.state = ResponseState::FailedOpenDevice;
    return response;
  }
  let mut port = tty_device.unwrap();
  let _ = port.clear(ClearBuffer::All);
  let _ = port.clear_break();
  let mut retry: u8 = 0;
  'outer: loop {
    if retry > 3 {
      response.state = ResponseState::MaxSendRetry;
      return response;
    }

    if retry != 0 {
      eprintln!("retry:{retry}");
      let _ = port.clear(ClearBuffer::All);
      std::thread::sleep(core::time::Duration::from_millis(u64::from(retry) * 100));
    }

    let chunks = data.chunks_exact(8);
    let rem = chunks.remainder();
    for chunk in chunks {
      let w_res = port.write(chunk);
      let _ = port.flush();
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

    let w_res = port.write(&end);
    let _ = port.flush();

    if w_res.is_err() {
      retry += 1;
      continue 'outer;
    }

    let mut buf = [0_u8; 6];
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

  std::thread::sleep(core::time::Duration::from_millis(200));
  read_serialport(&mut port)
}
