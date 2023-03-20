use anyhow::{bail, Context, Result};
use serialport::{DataBits, FlowControl, Parity, StopBits};

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

    if port.write_all(data).is_ok() {
        return port.read(buffer).map_err(Into::into);
    }

    bail!("failed to wirte data")
}
