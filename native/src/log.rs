use std::io::Write;

use anyhow::{bail, Result};
use flutter_rust_bridge::StreamSink;
use tracing_subscriber::fmt::MakeWriter;

/// Wrapper so that we can implement required Write and MakeWriter traits.
struct LogSink {
  sink: StreamSink<String>,
}

/// Write log lines to our Flutter's sink.
impl<'a> Write for &'a LogSink {
  fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
    let line = String::from_utf8_lossy(buf).to_string();
    self.sink.add(line);
    Ok(buf.len())
  }

  fn flush(&mut self) -> std::io::Result<()> {
    Ok(())
  }
}

impl<'a> MakeWriter<'a> for LogSink {
  type Writer = &'a LogSink;

  fn make_writer(&'a self) -> Self::Writer {
    self
  }
}

/// Public method that Dart will call into.
pub fn setup_logs(sink: StreamSink<String>) -> Result<()> {
  let log_sink = LogSink { sink };

  // Subscribe to tracing events and publish them to the UI
  if let Err(err) = tracing_subscriber::fmt()
    .with_max_level(tracing::Level::TRACE)
    .with_writer(log_sink)
    .try_init()
  {
    bail!("{}", err);
  }
  Ok(())
}
