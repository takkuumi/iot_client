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
// Generated by `flutter_rust_bridge`@ 1.76.0.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::*;
use std::{ffi::c_void, sync::Arc};

// Section: imports

use crate::{
  hal::{
    device::device_display::DeviceDisplay,
    serial::{
      baud_rate::BaudRate,
      data_bit::DataBit,
      parity::Parity,
      port_type::PortType,
      stop_bit::StopBit,
      undefine::Undefine,
      Configuration,
      Setting,
    },
    LogicControl,
  },
  serial::{ErrorKind, ResponseState, SerialResponse},
};

// Section: wire functions

fn wire_init_log_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "init_log",
      port: Some(port_),
      mode: FfiCallMode::Stream,
    },
    move || move |task_callback| init_log(task_callback.stream_sink()),
  )
}
fn wire_ble_validate_response_impl(port_: MessagePort, data: impl Wire2Api<Vec<u8>> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_validate_response",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_data = data.wire2api();
      move |task_callback| Ok(ble_validate_response(api_data))
    },
  )
}
fn wire_ble_response_parse_u16_impl(port_: MessagePort, data: impl Wire2Api<Vec<u8>> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_response_parse_u16",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_data = data.wire2api();
      move |task_callback| Ok(ble_response_parse_u16(api_data))
    },
  )
}
fn wire_ble_response_parse_bool_impl(
  port_: MessagePort,
  data: impl Wire2Api<Vec<u8>> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_response_parse_bool",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_data = data.wire2api();
      move |task_callback| Ok(ble_response_parse_bool(api_data))
    },
  )
}
fn wire_ble_ports_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_ports",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| Ok(ble_ports()),
  )
}
fn wire_ble_scan_impl(port_: MessagePort, typee: impl Wire2Api<u8> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_scan",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_typee = typee.wire2api();
      move |task_callback| Ok(ble_scan(api_typee))
    },
  )
}
fn wire_ble_lecconn_impl(
  port_: MessagePort,
  addr: impl Wire2Api<String> + UnwindSafe,
  add_type: impl Wire2Api<u8> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_lecconn",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_addr = addr.wire2api();
      let api_add_type = add_type.wire2api();
      move |task_callback| Ok(ble_lecconn(api_addr, api_add_type))
    },
  )
}
fn wire_ble_ledisc_impl(port_: MessagePort, index: impl Wire2Api<u8> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_ledisc",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_index = index.wire2api();
      move |task_callback| Ok(ble_ledisc(api_index))
    },
  )
}
fn wire_ble_lesend_impl(
  port_: MessagePort,
  index: impl Wire2Api<u8> + UnwindSafe,
  data: impl Wire2Api<String> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_lesend",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_index = index.wire2api();
      let api_data = data.wire2api();
      move |task_callback| Ok(ble_lesend(api_index, api_data))
    },
  )
}
fn wire_ble_tpmode_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_tpmode",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| Ok(ble_tpmode()),
  )
}
fn wire_ble_reboot_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_reboot",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| Ok(ble_reboot()),
  )
}
fn wire_ble_chinfo_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_chinfo",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| Ok(ble_chinfo()),
  )
}
fn wire_ble_uartcfg_impl(port_: MessagePort) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "ble_uartcfg",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || move |task_callback| Ok(ble_uartcfg()),
  )
}
fn wire_hal_generate_get_holdings_impl(
  port_: MessagePort,
  unit_id: impl Wire2Api<u8> + UnwindSafe,
  reg: impl Wire2Api<u16> + UnwindSafe,
  count: impl Wire2Api<u16> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_generate_get_holdings",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_unit_id = unit_id.wire2api();
      let api_reg = reg.wire2api();
      let api_count = count.wire2api();
      move |task_callback| Ok(hal_generate_get_holdings(api_unit_id, api_reg, api_count))
    },
  )
}
fn wire_hal_generate_get_coils_impl(
  port_: MessagePort,
  unit_id: impl Wire2Api<u8> + UnwindSafe,
  reg: impl Wire2Api<u16> + UnwindSafe,
  count: impl Wire2Api<u16> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_generate_get_coils",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_unit_id = unit_id.wire2api();
      let api_reg = reg.wire2api();
      let api_count = count.wire2api();
      move |task_callback| Ok(hal_generate_get_coils(api_unit_id, api_reg, api_count))
    },
  )
}
fn wire_hal_generate_set_coils_impl(
  port_: MessagePort,
  unit_id: impl Wire2Api<u8> + UnwindSafe,
  reg: impl Wire2Api<u16> + UnwindSafe,
  values: impl Wire2Api<Vec<u8>> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_generate_set_coils",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_unit_id = unit_id.wire2api();
      let api_reg = reg.wire2api();
      let api_values = values.wire2api();
      move |task_callback| Ok(hal_generate_set_coils(api_unit_id, api_reg, api_values))
    },
  )
}
fn wire_hal_generate_set_coil_impl(
  port_: MessagePort,
  unit_id: impl Wire2Api<u8> + UnwindSafe,
  reg: impl Wire2Api<u16> + UnwindSafe,
  value: impl Wire2Api<u8> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_generate_set_coil",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_unit_id = unit_id.wire2api();
      let api_reg = reg.wire2api();
      let api_value = value.wire2api();
      move |task_callback| Ok(hal_generate_set_coil(api_unit_id, api_reg, api_value))
    },
  )
}
fn wire_hal_generate_set_holding_impl(
  port_: MessagePort,
  unit_id: impl Wire2Api<u8> + UnwindSafe,
  reg: impl Wire2Api<u16> + UnwindSafe,
  value: impl Wire2Api<u16> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_generate_set_holding",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_unit_id = unit_id.wire2api();
      let api_reg = reg.wire2api();
      let api_value = value.wire2api();
      move |task_callback| Ok(hal_generate_set_holding(api_unit_id, api_reg, api_value))
    },
  )
}
fn wire_hal_generate_set_holdings_bulk_impl(
  port_: MessagePort,
  unit_id: impl Wire2Api<u8> + UnwindSafe,
  reg: impl Wire2Api<u16> + UnwindSafe,
  values: impl Wire2Api<Vec<u16>> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_generate_set_holdings_bulk",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_unit_id = unit_id.wire2api();
      let api_reg = reg.wire2api();
      let api_values = values.wire2api();
      move |task_callback| {
        Ok(hal_generate_set_holdings_bulk(
          api_unit_id,
          api_reg,
          api_values,
        ))
      }
    },
  )
}
fn wire_hex_encode_impl(port_: MessagePort, data: impl Wire2Api<Vec<u8>> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hex_encode",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_data = data.wire2api();
      move |task_callback| Ok(hex_encode(api_data))
    },
  )
}
fn wire_hex_decode_impl(port_: MessagePort, data: impl Wire2Api<String> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hex_decode",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_data = data.wire2api();
      move |task_callback| Ok(hex_decode(api_data))
    },
  )
}
fn wire_hal_new_logic_control_impl(
  port_: MessagePort,
  index: impl Wire2Api<u8> + UnwindSafe,
  scene: impl Wire2Api<u8> + UnwindSafe,
  values: impl Wire2Api<Vec<u8>> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_new_logic_control",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_index = index.wire2api();
      let api_scene = scene.wire2api();
      let api_values = values.wire2api();
      move |task_callback| Ok(hal_new_logic_control(api_index, api_scene, api_values))
    },
  )
}
fn wire_hal_generate_set_lc_holdings_impl(
  port_: MessagePort,
  unit_id: impl Wire2Api<u8> + UnwindSafe,
  logic_control: impl Wire2Api<LogicControl> + UnwindSafe,
) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_generate_set_lc_holdings",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_unit_id = unit_id.wire2api();
      let api_logic_control = logic_control.wire2api();
      move |task_callback| Ok(hal_generate_set_lc_holdings(api_unit_id, api_logic_control))
    },
  )
}
fn wire_convert_u16s_to_u8s_impl(port_: MessagePort, data: impl Wire2Api<Vec<u16>> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "convert_u16s_to_u8s",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_data = data.wire2api();
      move |task_callback| Ok(convert_u16s_to_u8s(api_data))
    },
  )
}
fn wire_hal_read_device_settings_impl(port_: MessagePort, index: impl Wire2Api<u8> + UnwindSafe) {
  FLUTTER_RUST_BRIDGE_HANDLER.wrap(
    WrapInfo {
      debug_name: "hal_read_device_settings",
      port: Some(port_),
      mode: FfiCallMode::Normal,
    },
    move || {
      let api_index = index.wire2api();
      move |task_callback| Ok(hal_read_device_settings(api_index))
    },
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

impl Wire2Api<u16> for u16 {
  fn wire2api(self) -> u16 {
    self
  }
}
impl Wire2Api<u8> for u8 {
  fn wire2api(self) -> u8 {
    self
  }
}

// Section: impl IntoDart

impl support::IntoDart for BaudRate {
  fn into_dart(self) -> support::DartAbi {
    match self {
      Self::BS300 => 0,
      Self::BS600 => 1,
      Self::BS1200 => 2,
      Self::BS2400 => 3,
      Self::BS4800 => 4,
      Self::BS9600 => 5,
      Self::BS19200 => 6,
      Self::BS115200 => 7,
    }
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for BaudRate {}

impl support::IntoDart for Configuration {
  fn into_dart(self) -> support::DartAbi {
    vec![
      self.data_bit.into_dart(),
      self.parity.into_dart(),
      self.stop_bit.into_dart(),
      self.baud_rate.into_dart(),
      self.undefine.into_dart(),
      self.port_type.into_dart(),
    ]
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for Configuration {}

impl support::IntoDart for DataBit {
  fn into_dart(self) -> support::DartAbi {
    match self {
      Self::BitWidth8 => 0,
      Self::BitWidth9 => 1,
    }
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for DataBit {}
impl support::IntoDart for DeviceDisplay {
  fn into_dart(self) -> support::DartAbi {
    vec![
      self.sn.into_dart(),
      self.location.into_dart(),
      self.rs485_1.into_dart(),
      self.rs485_2.into_dart(),
      self.rs485_3.into_dart(),
      self.bt.into_dart(),
      self.net.into_dart(),
      self.local_port1.into_dart(),
      self.local_port2.into_dart(),
      self.local_port3.into_dart(),
      self.local_port4.into_dart(),
      self.local_port5.into_dart(),
      self.local_port6.into_dart(),
      self.local_port7.into_dart(),
      self.local_port8.into_dart(),
      self.local_ip.into_dart(),
      self.subnet_mask.into_dart(),
      self.gateway.into_dart(),
      self.dns.into_dart(),
      self.mac.into_dart(),
      self.remote_port.into_dart(),
      self.remote_ip.into_dart(),
    ]
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for DeviceDisplay {}

impl support::IntoDart for ErrorKind {
  fn into_dart(self) -> support::DartAbi {
    match self {
      Self::FailedOpenDevice => 0,
      Self::Timeout => 1,
      Self::Unknown => 2,
      Self::FailedReadData => 3,
      Self::ReadResponseError => 4,
      Self::FailedWrite => 5,
      Self::DeviceBusy => 6,
      Self::ClearBufferError => 7,
      Self::FlushBufferError => 8,
    }
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for ErrorKind {}

impl support::IntoDart for LogicControl {
  fn into_dart(self) -> support::DartAbi {
    vec![
      self.index.into_dart(),
      self.scene.into_dart(),
      self.values.into_dart(),
    ]
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for LogicControl {}

impl support::IntoDart for Parity {
  fn into_dart(self) -> support::DartAbi {
    match self {
      Self::Nil => 0,
      Self::Odd => 1,
      Self::Even => 2,
    }
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for Parity {}
impl support::IntoDart for PortType {
  fn into_dart(self) -> support::DartAbi {
    match self {
      Self::Nil => 0,
      Self::Master => 1,
      Self::Slave => 2,
    }
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for PortType {}
impl support::IntoDart for ResponseState {
  fn into_dart(self) -> support::DartAbi {
    match self {
      Self::Ok => vec![0.into_dart()],
      Self::Error(field0) => vec![1.into_dart(), field0.into_dart()],
    }
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for ResponseState {}
impl support::IntoDart for SerialResponse {
  fn into_dart(self) -> support::DartAbi {
    vec![self.state.into_dart(), self.data.into_dart()].into_dart()
  }
}
impl support::IntoDartExceptPrimitive for SerialResponse {}

impl support::IntoDart for Setting {
  fn into_dart(self) -> support::DartAbi {
    vec![
      self.configuration.into_dart(),
      self.slave_addr.into_dart(),
      self.retry.into_dart(),
      self.duration.into_dart(),
      self.loop_interval.into_dart(),
    ]
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for Setting {}

impl support::IntoDart for StopBit {
  fn into_dart(self) -> support::DartAbi {
    match self {
      Self::Bit1 => 0,
      Self::Bit2 => 1,
    }
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for StopBit {}

impl support::IntoDart for Undefine {
  fn into_dart(self) -> support::DartAbi {
    match self {
      Self::Def => 0,
    }
    .into_dart()
  }
}
impl support::IntoDartExceptPrimitive for Undefine {}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

/// cbindgen:ignore
#[cfg(target_family = "wasm")]
#[path = "bridge_generated.web.rs"]
mod web;
#[cfg(target_family = "wasm")]
pub use web::*;

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;
