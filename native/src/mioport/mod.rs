#[cfg(test)]
mod test {
  use mio::{Events, Interest, Poll, Token};

  use std::{
    env,
    io,
    io::{IoSlice, Read, Write},
    str,
  };

  use mio_serial::{SerialPort, SerialPortBuilderExt};

  const SERIAL_TOKEN: Token = Token(0);

  #[cfg(unix)]
  const DEFAULT_TTY: &str = "/dev/tty.usbserial-1410";
  #[cfg(windows)]
  const DEFAULT_TTY: &str = "COM6";

  const DEFAULT_BAUD: u32 = 115200;

  #[test]
  pub fn it_works() -> io::Result<()> {
    // let baud = DEFAULT_BAUD;

    // Create a poll instance.
    let mut poll = Poll::new()?;
    // Create storage for events. Since we will only register a single serialport, a
    // capacity of 1 will do.
    let mut events = Events::with_capacity(1);

    // Create the serial port
    println!("Opening {} at 9600,8N1", DEFAULT_TTY);
    let mut rx = mio_serial::new(DEFAULT_TTY, DEFAULT_BAUD).open_native_async()?;
    rx.set_timeout(core::time::Duration::from_millis(100));
    // #[cfg(unix)]
    // let mut rx = mio_serial::TTYPort::open(&builder)?;
    // #[cfg(windows)]
    // let mut rx = mio_serial::COMPort::open(&builder)?;

    poll
      .registry()
      .register(&mut rx, SERIAL_TOKEN, Interest::WRITABLE)
      .unwrap();

    poll.poll(&mut events, None)?;

    for event in &events {
      if event.token() == Token(0) && event.is_writable() {
        // The socket connected (probably, it could still be a spurious
        // wakeup)
        let res = rx.write(b"AT+SCAN=1");
        eprintln!("write_all_vectored: {:?}", res);
        break;
      }
    }

    poll
      .registry()
      .register(&mut rx, SERIAL_TOKEN, Interest::READABLE)
      .unwrap();

    let mut buf = [0u8; 1024];

    loop {
      // Poll to check if we have events waiting for us.
      poll.poll(&mut events, None)?;

      // Process each event.
      for event in events.iter() {
        // Validate the token we registered our socket with,
        // in this example it will only ever be one but we
        // make sure it's valid none the less.
        if event.token() == SERIAL_TOKEN {
          loop {
            // In this loop we receive all packets queued for the socket.
            match rx.read(&mut buf) {
              Ok(count) => {
                println!("{:?}", String::from_utf8_lossy(&buf[..count]))
              }
              Err(ref e) if e.kind() == io::ErrorKind::WouldBlock => {
                break;
              }
              Err(e) => {
                println!("Quitting due to read error: {}", e);
                return Err(e);
              }
            }
          }
        } else {
          // This should never happen as we only registered our
          // `UdpSocket` using the `UDP_SOCKET` token, but if it ever
          // does we'll log it.
          // warn!("Got event for unexpected token: {:?}", event);
        }
      }
    }
  }
}
