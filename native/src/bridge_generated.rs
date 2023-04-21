#![allow(
  non_camel_case_types,
  unused,
  clippy::redundant_closure,
  clippy::useless_conversion,
  clippy::unit_arg,
  clippy::double_parens,
  non_snake_case,
  clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.75.1.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::*;
use std::{ffi::c_void, sync::Arc};

// Section: imports

// Section: wire functions

fn wire_get_ndid_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "get_ndid",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| get_ndid(),
  )
}
fn wire_at_ndrpt_impl(
  port_: MessagePort,
  id: impl Wire2Api<String> + UnwindSafe,
  data: impl Wire2Api<String> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "at_ndrpt",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_id = id.wire2api();
      let api_data = data.wire2api();
      move |task_callback| at_ndrpt(api_id, api_data)
    },
  )
}
fn wire_at_ndrpt_test_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "at_ndrpt_test",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| at_ndrpt_test(),
  )
}
fn wire_set_ndid_impl(port_: MessagePort, id: impl Wire2Api<String> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "set_ndid",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_id = id.wire2api();
      move |task_callback| set_ndid(api_id)
    },
  )
}
fn wire_set_mode_impl(port_: MessagePort, mode: impl Wire2Api<u8> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "set_mode",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_mode = mode.wire2api();
      move |task_callback| set_mode(api_mode)
    },
  )
}
fn wire_ndreset_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ndreset",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| ndreset(),
  )
}
fn wire_restore_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "restore",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| restore(),
  )
}
fn wire_reboot_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "reboot",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| reboot(),
  )
}
fn wire_print_a_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "print_a",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| Ok(print_a()),
  )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
  fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
  *mut S: Wire2Api<T>,
{
  fn wire2api(self) -> Option<T> {
    (!self.is_null()).then(|| self.wire2api())
  }
}

impl Wire2Api<u8> for u8 {
  fn wire2api(self) -> u8 {
    self
  }
}

// Section: impl IntoDart

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;
