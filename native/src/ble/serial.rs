use std::io::ErrorKind;

use anyhow::{Context, Result};
use serialport::{ClearBuffer, DataBits, FlowControl, StopBits};

// serialport::new("/dev/tty.usbserial-1430", 115200)
// serialport::new("/dev/tty.usbserial-1410", 115200)
// ttySWK0

pub fn open_tty_swk0(millis: u64) -> Result<Box<dyn serialport::SerialPort>> {
  serialport::new("/dev/ttySWK0", 115200)
    .data_bits(DataBits::Eight)
    .stop_bits(StopBits::One)
    .flow_control(FlowControl::None)
    .timeout(core::time::Duration::from_millis(millis))
    .open()
    .context("failed to open device!")
}

pub fn read_serialport(
  port: &mut Box<dyn serialport::SerialPort>,
  buffer: &mut Vec<u8>,
) -> Result<()> {
  std::thread::sleep(core::time::Duration::from_millis(80));
  let mut count: u8 = 0;
  'inner: loop {
    let mut resp_buf = [0_u8; 8];
    std::thread::sleep(core::time::Duration::from_millis(20));
    match port.read(&mut resp_buf) {
      Err(_) => {
        if count > 5 {
          return Err(anyhow::Error::msg("蓝牙接收失败"));
        }
        count += 1;
      }
      Ok(size) => {
        if size != 0 {
          count = 0;
          buffer.extend_from_slice(&resp_buf[..size]);
          continue 'inner;
        }
        break 'inner;
      }
    }
  }
  Ok(())
}

pub fn send_serialport(data: &[u8], buffer: &mut Vec<u8>) -> Result<()> {
  let mut port = open_tty_swk0(100)?;
  let mut retry: u8 = 0;
  'outer: loop {
    if retry > 5 {
      return Err(anyhow::Error::msg("蓝牙发送失败"));
    }

    if retry != 0 {
      let _ = port.clear(ClearBuffer::Input);
      std::thread::sleep(core::time::Duration::from_millis(100));
    }

    let chunks = data.chunks_exact(8);
    let rem = chunks.remainder();
    for chunk in chunks {
      if port.write(chunk).is_err() {
        retry += 1;
        continue 'outer;
      }
    }

    let mut end = vec![];
    if !rem.is_empty() {
      end.extend_from_slice(rem);
    }
    end.push(b'\r');
    end.push(b'\n');

    if port.write(&end).is_err() {
      retry += 1;
      continue 'outer;
    }

    let mut buf = [0_u8; 6];
    let size = port.read(&mut buf)?;
    buffer.extend_from_slice(&buf[..size]);

    let bt_state = String::from_utf8_lossy(&buf);

    if bt_state.contains("ERR") {
      retry += 1;
      continue 'outer;
    }

    break 'outer;
  }
  let _ = port.clear(ClearBuffer::Input);
  let res = read_serialport(&mut port, buffer);
  let _ = port.clear(ClearBuffer::Output);
  res
}
