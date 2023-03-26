use anyhow::{bail, Context, Result};
use serialport::{DataBits, FlowControl, StopBits};

fn open_serialport() -> Result<Box<dyn serialport::SerialPort>> {
  serialport::new("/dev/ttySWK0", 115200)
    .data_bits(DataBits::Eight)
    .stop_bits(StopBits::One)
    .flow_control(FlowControl::None)
    .timeout(core::time::Duration::from_secs(10))
    .open()
    .context("failed to open device!")
}

pub fn send_serialport(data: &[u8], buffer: &mut [u8]) -> Result<usize> {
  let mut port = open_serialport()?;

  if port.write(data).is_ok() {
    port.flush()?;
    return port.read(buffer).map_err(Into::into);
  }

  bail!("failed to wirte data")
}

pub fn send_serialport2(data: &[u8]) -> Result<usize> {
  let mut port = open_serialport()?;

  if port.write(data).is_ok() {
    loop {
      let mut buffer = [0_u8; 200];
      match port.read(&mut buffer) {
        Ok(size) => {
          println!("size: {}", size);
          println!("buffer: {:?}", buffer);
        }
        Err(err) => {
          println!("error");
          return Err(err.into());
        }
      };
    }
  }

  bail!("failed to wirte data")
}
