use anyhow::{bail, Context, Ok, Result};
use serialport::{DataBits, FlowControl, StopBits};

fn open_tty_swk0() -> Result<Box<dyn serialport::SerialPort>> {
  serialport::new("/dev/ttySWK0", 115200)
    .data_bits(DataBits::Eight)
    .stop_bits(StopBits::One)
    .flow_control(FlowControl::None)
    .timeout(core::time::Duration::from_secs(10))
    .open()
    .context("failed to open device!")
}

pub fn send_serialport(data: &[u8], buffer: &mut Vec<u8>) -> Result<()> {
  let mut port = open_tty_swk0()?;

  if port.write_all(data).is_ok() {
    let mut buf = [0_u8; 9];
    let size = port.read(&mut buf)?;
    buffer.extend_from_slice(&buf[..size]);

    let mut resp_buf = [0_u8; 40];
    if port.read_exact(&mut resp_buf).is_ok() {
      buffer.extend_from_slice(&resp_buf);
    }
    return Ok(());
  }

  bail!("failed to wirte data!")
}
