use std::io::ErrorKind;

use anyhow::{Context, Result};
use serialport::{ClearBuffer, DataBits, FlowControl, SerialPort, StopBits};

static GLOBAL_TTY_SWK0: std::sync::Mutex<Option<Box<dyn serialport::SerialPort>>> =
  std::sync::Mutex::new(None);

pub fn open_tty_swk0(millis: u64) -> Result<Box<dyn serialport::SerialPort>> {
  serialport::new("/dev/ttySWK0", 115200)
    .data_bits(DataBits::Eight)
    .stop_bits(StopBits::One)
    .flow_control(FlowControl::None)
    .timeout(core::time::Duration::from_millis(millis))
    .open()
    .context("failed to open device!")
}

pub fn init_tty_swk0(millis: u64) -> Result<()> {
  let mut instance = GLOBAL_TTY_SWK0.lock().unwrap();
  if instance.is_none() {
    let port = open_tty_swk0(millis)?;
    port.clear(ClearBuffer::All)?;
    instance.replace(port);
  }

  Ok(())
}

// serialport::new("/dev/tty.usbserial-1410", 115200)
// ttySWK0

pub fn send_serialport(data: &[u8], buffer: &mut Vec<u8>) -> Result<()> {
  let mut port = open_tty_swk0(70)?;
  let mut retry: u8 = 0;
  loop {
    if retry > 5 {
      return Err(anyhow::Error::msg("蓝牙发送失败"));
    }
    let _ = port.clear(ClearBuffer::All);
    if port.write_all(data).is_ok() {
      let _ = port.flush();
      let mut buf = [0_u8; 6];
      let size = port.read(&mut buf)?;
      buffer.extend_from_slice(&buf[..size]);

      let bt_state = String::from_utf8_lossy(&buf);

      if bt_state.contains("ERR") {
        retry += 1;
        std::thread::sleep(core::time::Duration::from_millis(10));
        continue;
      }

      let mut count: u8 = 0;
      loop {
        let mut resp_buf = [0_u8; 6];
        match port.read(&mut resp_buf) {
          Err(e) => {
            if e.kind() == ErrorKind::TimedOut {
              if count > 3 {
                break;
              }
              count += 1;
              continue;
            }
            break;
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
    }
    let _ = port.clear_break();
    std::thread::sleep(core::time::Duration::from_millis(5));
    return Ok(());
  }
}

pub fn send_serialport2(data: &[u8], buffer: &mut Vec<u8>) -> Result<()> {
  let mut port = GLOBAL_TTY_SWK0
    .lock()
    .unwrap()
    .as_ref()
    .unwrap()
    .try_clone()?;
  let mut retry: u8 = 0;
  loop {
    if retry > 5 {
      return Err(anyhow::Error::msg("蓝牙发送失败"));
    }

    if port.write(data).is_ok() {
      let _ = port.flush();
      let _ = port.clear(ClearBuffer::Input);

      let mut buf = [0_u8; 6];
      let size = port.read(&mut buf)?;
      buffer.extend_from_slice(&buf[..size]);

      let bt_state = String::from_utf8_lossy(&buf);

      if bt_state.contains("ERR") {
        retry += 1;
        let _ = port.clear(ClearBuffer::All);
        let _ = port.flush();
        std::thread::sleep(core::time::Duration::from_millis(100));
        continue;
      }

      let mut count: u8 = 0;
      loop {
        let mut resp_buf = [0_u8; 8];
        match port.read(&mut resp_buf) {
          Err(e) => {
            if e.kind() == ErrorKind::TimedOut {
              if count > 3 {
                break;
              }
              count += 1;
              continue;
            }
            break;
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
    }
    let _ = port.clear_break();
    std::thread::sleep(core::time::Duration::from_millis(5));
    return Ok(());
  }
}
