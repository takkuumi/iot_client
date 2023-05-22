#![feature(lazy_cell)]
#![feature(write_all_vectored)]

mod api;
mod ble;
mod bridge_generated;
mod hal;
mod mioport;
mod serial;

pub use serial::SerialResponse;
