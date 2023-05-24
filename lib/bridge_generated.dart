// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.75.3.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import "bridge_definitions.dart";
import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';
import 'ffi.io.dart' if (dart.library.html) 'ffi.web.dart';
import 'bridge_generated.io.dart'
    if (dart.library.html) 'bridge_generated.web.dart';

class NativeImpl implements Native {
  final NativePlatform _platform;
  factory NativeImpl(ExternalLibrary dylib) =>
      NativeImpl.raw(NativePlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory NativeImpl.wasm(FutureOr<WasmModule> module) =>
      NativeImpl(module as ExternalLibrary);
  NativeImpl.raw(this._platform);
  Stream<String> initLog({dynamic hint}) {
    return _platform.executeStream(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_init_log(port_),
      parseSuccessData: _wire2api_String,
      constMeta: kInitLogConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kInitLogConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "init_log",
        argNames: [],
      );

  Future<bool> bleValidateResponse({required Uint8List data, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(data);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_ble_validate_response(port_, arg0),
      parseSuccessData: _wire2api_bool,
      constMeta: kBleValidateResponseConstMeta,
      argValues: [data],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleValidateResponseConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_validate_response",
        argNames: ["data"],
      );

  Future<Uint16List?> bleResponseParseU16(
      {required Uint8List data, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(data);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_ble_response_parse_u16(port_, arg0),
      parseSuccessData: _wire2api_opt_uint_16_list,
      constMeta: kBleResponseParseU16ConstMeta,
      argValues: [data],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleResponseParseU16ConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_response_parse_u16",
        argNames: ["data"],
      );

  Future<Uint8List?> bleResponseParseBool(
      {required Uint8List data, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(data);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_ble_response_parse_bool(port_, arg0),
      parseSuccessData: _wire2api_opt_uint_8_list,
      constMeta: kBleResponseParseBoolConstMeta,
      argValues: [data],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleResponseParseBoolConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_response_parse_bool",
        argNames: ["data"],
      );

  Future<String> blePorts({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_ports(port_),
      parseSuccessData: _wire2api_String,
      constMeta: kBlePortsConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBlePortsConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_ports",
        argNames: [],
      );

  Future<SerialResponse> bleScan({required int typee, dynamic hint}) {
    var arg0 = api2wire_u8(typee);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_scan(port_, arg0),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleScanConstMeta,
      argValues: [typee],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleScanConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_scan",
        argNames: ["typee"],
      );

  Future<bool> bleLecconn(
      {required String addr, required int addType, dynamic hint}) {
    var arg0 = _platform.api2wire_String(addr);
    var arg1 = api2wire_u8(addType);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_lecconn(port_, arg0, arg1),
      parseSuccessData: _wire2api_bool,
      constMeta: kBleLecconnConstMeta,
      argValues: [addr, addType],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleLecconnConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_lecconn",
        argNames: ["addr", "addType"],
      );

  Future<bool> bleLedisc({required int index, dynamic hint}) {
    var arg0 = api2wire_u8(index);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_ledisc(port_, arg0),
      parseSuccessData: _wire2api_bool,
      constMeta: kBleLediscConstMeta,
      argValues: [index],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleLediscConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_ledisc",
        argNames: ["index"],
      );

  Future<SerialResponse> bleLesend(
      {required int index, required String data, dynamic hint}) {
    var arg0 = api2wire_u8(index);
    var arg1 = _platform.api2wire_String(data);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_lesend(port_, arg0, arg1),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleLesendConstMeta,
      argValues: [index, data],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleLesendConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_lesend",
        argNames: ["index", "data"],
      );

  Future<void> bleTpmode({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_tpmode(port_),
      parseSuccessData: _wire2api_unit,
      constMeta: kBleTpmodeConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleTpmodeConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_tpmode",
        argNames: [],
      );

  Future<void> bleReboot({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_reboot(port_),
      parseSuccessData: _wire2api_unit,
      constMeta: kBleRebootConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleRebootConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_reboot",
        argNames: [],
      );

  Future<SerialResponse> bleChinfo({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_chinfo(port_),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleChinfoConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleChinfoConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_chinfo",
        argNames: [],
      );

  Future<SerialResponse> bleUartcfg({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_uartcfg(port_),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleUartcfgConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleUartcfgConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_uartcfg",
        argNames: [],
      );

  Future<String> halGenerateGetHoldings(
      {required int unitId,
      required int reg,
      required int count,
      dynamic hint}) {
    var arg0 = api2wire_u8(unitId);
    var arg1 = api2wire_u16(reg);
    var arg2 = api2wire_u16(count);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_hal_generate_get_holdings(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_String,
      constMeta: kHalGenerateGetHoldingsConstMeta,
      argValues: [unitId, reg, count],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalGenerateGetHoldingsConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_generate_get_holdings",
        argNames: ["unitId", "reg", "count"],
      );

  Future<String> halGenerateGetCoils(
      {required int unitId,
      required int reg,
      required int count,
      dynamic hint}) {
    var arg0 = api2wire_u8(unitId);
    var arg1 = api2wire_u16(reg);
    var arg2 = api2wire_u16(count);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_hal_generate_get_coils(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_String,
      constMeta: kHalGenerateGetCoilsConstMeta,
      argValues: [unitId, reg, count],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalGenerateGetCoilsConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_generate_get_coils",
        argNames: ["unitId", "reg", "count"],
      );

  Future<String> halGenerateSetCoils(
      {required int unitId,
      required int reg,
      required Uint8List values,
      dynamic hint}) {
    var arg0 = api2wire_u8(unitId);
    var arg1 = api2wire_u16(reg);
    var arg2 = _platform.api2wire_uint_8_list(values);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_hal_generate_set_coils(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_String,
      constMeta: kHalGenerateSetCoilsConstMeta,
      argValues: [unitId, reg, values],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetCoilsConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_generate_set_coils",
        argNames: ["unitId", "reg", "values"],
      );

  Future<String> halGenerateSetCoil(
      {required int unitId,
      required int reg,
      required int value,
      dynamic hint}) {
    var arg0 = api2wire_u8(unitId);
    var arg1 = api2wire_u16(reg);
    var arg2 = api2wire_u8(value);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_hal_generate_set_coil(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_String,
      constMeta: kHalGenerateSetCoilConstMeta,
      argValues: [unitId, reg, value],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetCoilConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_generate_set_coil",
        argNames: ["unitId", "reg", "value"],
      );

  Future<String> halGenerateSetHolding(
      {required int unitId,
      required int reg,
      required int value,
      dynamic hint}) {
    var arg0 = api2wire_u8(unitId);
    var arg1 = api2wire_u16(reg);
    var arg2 = api2wire_u16(value);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_hal_generate_set_holding(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_String,
      constMeta: kHalGenerateSetHoldingConstMeta,
      argValues: [unitId, reg, value],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetHoldingConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_generate_set_holding",
        argNames: ["unitId", "reg", "value"],
      );

  Future<String> halGenerateSetHoldingsBulk(
      {required int unitId,
      required int reg,
      required Uint16List values,
      dynamic hint}) {
    var arg0 = api2wire_u8(unitId);
    var arg1 = api2wire_u16(reg);
    var arg2 = _platform.api2wire_uint_16_list(values);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_hal_generate_set_holdings_bulk(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_String,
      constMeta: kHalGenerateSetHoldingsBulkConstMeta,
      argValues: [unitId, reg, values],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetHoldingsBulkConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_generate_set_holdings_bulk",
        argNames: ["unitId", "reg", "values"],
      );

  Future<String> hexEncode({required Uint8List data, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(data);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_hex_encode(port_, arg0),
      parseSuccessData: _wire2api_String,
      constMeta: kHexEncodeConstMeta,
      argValues: [data],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHexEncodeConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hex_encode",
        argNames: ["data"],
      );

  Future<Uint8List> hexDecode({required String data, dynamic hint}) {
    var arg0 = _platform.api2wire_String(data);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_hex_decode(port_, arg0),
      parseSuccessData: _wire2api_uint_8_list,
      constMeta: kHexDecodeConstMeta,
      argValues: [data],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHexDecodeConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hex_decode",
        argNames: ["data"],
      );

  Future<LogicControl> halNewLogicControl(
      {required int index,
      required int scene,
      required Uint8List values,
      dynamic hint}) {
    var arg0 = api2wire_u8(index);
    var arg1 = api2wire_u8(scene);
    var arg2 = _platform.api2wire_uint_8_list(values);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_hal_new_logic_control(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_logic_control,
      constMeta: kHalNewLogicControlConstMeta,
      argValues: [index, scene, values],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalNewLogicControlConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_new_logic_control",
        argNames: ["index", "scene", "values"],
      );

  Future<String> halGenerateSetLcHoldings(
      {required int unitId, required LogicControl logicControl, dynamic hint}) {
    var arg0 = api2wire_u8(unitId);
    var arg1 = _platform.api2wire_box_autoadd_logic_control(logicControl);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_hal_generate_set_lc_holdings(port_, arg0, arg1),
      parseSuccessData: _wire2api_String,
      constMeta: kHalGenerateSetLcHoldingsConstMeta,
      argValues: [unitId, logicControl],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetLcHoldingsConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_generate_set_lc_holdings",
        argNames: ["unitId", "logicControl"],
      );

  Future<Uint8List> convertU16SToU8S({required Uint16List data, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_16_list(data);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_convert_u16s_to_u8s(port_, arg0),
      parseSuccessData: _wire2api_uint_8_list,
      constMeta: kConvertU16SToU8SConstMeta,
      argValues: [data],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kConvertU16SToU8SConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "convert_u16s_to_u8s",
        argNames: ["data"],
      );

  Future<DeviceDisplay?> halReadDeviceSettings(
      {required int index, dynamic hint}) {
    var arg0 = api2wire_u8(index);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_hal_read_device_settings(port_, arg0),
      parseSuccessData: _wire2api_opt_box_autoadd_device_display,
      constMeta: kHalReadDeviceSettingsConstMeta,
      argValues: [index],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalReadDeviceSettingsConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_read_device_settings",
        argNames: ["index"],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  String _wire2api_String(dynamic raw) {
    return raw as String;
  }

  BaudRate _wire2api_baud_rate(dynamic raw) {
    return BaudRate.values[raw as int];
  }

  bool _wire2api_bool(dynamic raw) {
    return raw as bool;
  }

  DeviceDisplay _wire2api_box_autoadd_device_display(dynamic raw) {
    return _wire2api_device_display(raw);
  }

  Configuration _wire2api_configuration(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 6)
      throw Exception('unexpected arr length: expect 6 but see ${arr.length}');
    return Configuration(
      dataBit: _wire2api_data_bit(arr[0]),
      parity: _wire2api_parity(arr[1]),
      stopBit: _wire2api_stop_bit(arr[2]),
      baudRate: _wire2api_baud_rate(arr[3]),
      undefine: _wire2api_undefine(arr[4]),
      portType: _wire2api_port_type(arr[5]),
    );
  }

  DataBit _wire2api_data_bit(dynamic raw) {
    return DataBit.values[raw as int];
  }

  DeviceDisplay _wire2api_device_display(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 22)
      throw Exception('unexpected arr length: expect 22 but see ${arr.length}');
    return DeviceDisplay(
      sn: _wire2api_String(arr[0]),
      location: _wire2api_String(arr[1]),
      rs4851: _wire2api_setting(arr[2]),
      rs4852: _wire2api_setting(arr[3]),
      rs4853: _wire2api_setting(arr[4]),
      bt: _wire2api_setting(arr[5]),
      net: _wire2api_setting(arr[6]),
      localPort1: _wire2api_u16(arr[7]),
      localPort2: _wire2api_u16(arr[8]),
      localPort3: _wire2api_u16(arr[9]),
      localPort4: _wire2api_u16(arr[10]),
      localPort5: _wire2api_u16(arr[11]),
      localPort6: _wire2api_u16(arr[12]),
      localPort7: _wire2api_u16(arr[13]),
      localPort8: _wire2api_u16(arr[14]),
      localIp: _wire2api_String(arr[15]),
      subnetMask: _wire2api_String(arr[16]),
      gateway: _wire2api_String(arr[17]),
      dns: _wire2api_String(arr[18]),
      mac: _wire2api_String(arr[19]),
      remotePort: _wire2api_u16(arr[20]),
      remoteIp: _wire2api_String(arr[21]),
    );
  }

  ErrorKind _wire2api_error_kind(dynamic raw) {
    return ErrorKind.values[raw as int];
  }

  int _wire2api_i32(dynamic raw) {
    return raw as int;
  }

  LogicControl _wire2api_logic_control(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return LogicControl(
      index: _wire2api_u8(arr[0]),
      scene: _wire2api_u8(arr[1]),
      values: _wire2api_uint_8_list(arr[2]),
    );
  }

  DeviceDisplay? _wire2api_opt_box_autoadd_device_display(dynamic raw) {
    return raw == null ? null : _wire2api_box_autoadd_device_display(raw);
  }

  Uint16List? _wire2api_opt_uint_16_list(dynamic raw) {
    return raw == null ? null : _wire2api_uint_16_list(raw);
  }

  Uint8List? _wire2api_opt_uint_8_list(dynamic raw) {
    return raw == null ? null : _wire2api_uint_8_list(raw);
  }

  Parity _wire2api_parity(dynamic raw) {
    return Parity.values[raw as int];
  }

  PortType _wire2api_port_type(dynamic raw) {
    return PortType.values[raw as int];
  }

  ResponseState _wire2api_response_state(dynamic raw) {
    switch (raw[0]) {
      case 0:
        return ResponseState_Ok();
      case 1:
        return ResponseState_Error(
          _wire2api_error_kind(raw[1]),
        );
      default:
        throw Exception("unreachable");
    }
  }

  SerialResponse _wire2api_serial_response(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return SerialResponse(
      state: _wire2api_response_state(arr[0]),
      data: _wire2api_opt_uint_8_list(arr[1]),
    );
  }

  Setting _wire2api_setting(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return Setting(
      configuration: _wire2api_configuration(arr[0]),
      slaveAddr: _wire2api_u16(arr[1]),
      retry: _wire2api_u16(arr[2]),
      duration: _wire2api_u16(arr[3]),
      loopInterval: _wire2api_u16(arr[4]),
    );
  }

  StopBit _wire2api_stop_bit(dynamic raw) {
    return StopBit.values[raw as int];
  }

  int _wire2api_u16(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint16List _wire2api_uint_16_list(dynamic raw) {
    return raw as Uint16List;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }

  Undefine _wire2api_undefine(dynamic raw) {
    return Undefine.values[raw as int];
  }

  void _wire2api_unit(dynamic raw) {
    return;
  }
}

// Section: api2wire

@protected
int api2wire_u16(int raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer
