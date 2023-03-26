use std::sync::Mutex;

use anyhow::{bail, Context, Ok, Result};
use once_cell::sync::Lazy;
use serialport::{DataBits, FlowControl, StopBits};

static TTYSWK0: Lazy<Mutex<Option<Box<dyn serialport::SerialPort>>>> =
  Lazy::new(|| Mutex::new(None));

fn open_tty_swk0() -> Result<Box<dyn serialport::SerialPort>> {
  serialport::new("/dev/ttySWK0", 115200)
  // serialport::new("/dev/tty.usbserial-1410", 115200)
    .data_bits(DataBits::Eight)
    .stop_bits(StopBits::One)
    .flow_control(FlowControl::None)
    .timeout(core::time::Duration::from_secs(5))
    .open()
    .context("failed to open device!")
}

pub fn send_serialport(data: &[u8], buffer: &mut Vec<u8>) -> Result<()> {
  let mut port = open_tty_swk0()?;

  if port.write_all(data).is_ok() {
    let mut buf = [0_u8; 6];
    let size = port.read(&mut buf)?;
    buffer.extend_from_slice(&buf[..size]);

    // // read data

    // let mut data_seg = [0_u8; 18];
    // let size = port.read(&mut data_seg)?;
    // buffer.extend_from_slice(&data_seg[..size]);
    // if size < 18 {
    //   return Ok(());
    // }

    // let mut count = [0_u8; 2];
    // let size = port.read(&mut count)?;
    // buffer.extend_from_slice(&count[..size]);
    // if size < 2 {
    //   return Ok(());
    // }

    // let i = String::from_utf8_lossy(&count);
    // let capacity = i.parse::<usize>()?;

    // if capacity == 0 {
    //   port.clear_break()?;
    //   return Ok(());
    // }
    // let mut data = vec![0; capacity];
    // let size = port.read_exact(&mut data)?;
    // buffer.extend_from_slice(&data[..]);

    // if size < capacity {
    //   return Ok(());
    // }

    loop {
      let mut resp_buf = [0_u8; 6];
      match port.read(&mut resp_buf) {
        Err(e) => {
          eprintln!("error: {:?}", e);
          break;
        }
        core::result::Result::Ok(size) => {
          eprintln!("size: {:?}", size);
          if size < 4 {
            break;
          }
          buffer.extend_from_slice(&resp_buf[..size]);
        }
      }
    }

    return Ok(());
  }

  bail!("failed to wirte data!")
}
