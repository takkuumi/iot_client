// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.75.1.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import "bridge_definitions.dart";
import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

import 'dart:ffi' as ffi;

class NativeImpl implements Native {
  final NativePlatform _platform;
  factory NativeImpl(ExternalLibrary dylib) =>
      NativeImpl.raw(NativePlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory NativeImpl.wasm(FutureOr<WasmModule> module) =>
      NativeImpl(module as ExternalLibrary);
  NativeImpl.raw(this._platform);
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

  Future<int?> bleResponseParseU16(
      {required Uint8List data, required int unitId, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(data);
    var arg1 = api2wire_u8(unitId);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_ble_response_parse_u16(port_, arg0, arg1),
      parseSuccessData: _wire2api_opt_box_autoadd_u16,
      constMeta: kBleResponseParseU16ConstMeta,
      argValues: [data, unitId],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleResponseParseU16ConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_response_parse_u16",
        argNames: ["data", "unitId"],
      );

  Future<SerialResponse> bleGetNdid({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_get_ndid(port_),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleGetNdidConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleGetNdidConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_get_ndid",
        argNames: [],
      );

  Future<SerialResponse> bleAtNdrpt(
      {required String id,
      required String data,
      required int retry,
      dynamic hint}) {
    var arg0 = _platform.api2wire_String(id);
    var arg1 = _platform.api2wire_String(data);
    var arg2 = api2wire_u8(retry);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_ble_at_ndrpt(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleAtNdrptConstMeta,
      argValues: [id, data, retry],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleAtNdrptConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_at_ndrpt",
        argNames: ["id", "data", "retry"],
      );

  Future<SerialResponse> bleAtNdrptData(
      {required String id,
      required String data,
      required int retry,
      dynamic hint}) {
    var arg0 = _platform.api2wire_String(id);
    var arg1 = _platform.api2wire_String(data);
    var arg2 = api2wire_u8(retry);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_ble_at_ndrpt_data(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleAtNdrptDataConstMeta,
      argValues: [id, data, retry],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleAtNdrptDataConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_at_ndrpt_data",
        argNames: ["id", "data", "retry"],
      );

  Future<SerialResponse> bleAtNdrptTest({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_at_ndrpt_test(port_),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleAtNdrptTestConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleAtNdrptTestConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_at_ndrpt_test",
        argNames: [],
      );

  Future<SerialResponse> bleSetNdid({required String id, dynamic hint}) {
    var arg0 = _platform.api2wire_String(id);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_set_ndid(port_, arg0),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleSetNdidConstMeta,
      argValues: [id],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleSetNdidConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_set_ndid",
        argNames: ["id"],
      );

  Future<SerialResponse> bleSetMode({required int mode, dynamic hint}) {
    var arg0 = api2wire_u8(mode);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_set_mode(port_, arg0),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleSetModeConstMeta,
      argValues: [mode],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleSetModeConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_set_mode",
        argNames: ["mode"],
      );

  Future<SerialResponse> bleNdreset({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_ndreset(port_),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleNdresetConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleNdresetConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_ndreset",
        argNames: [],
      );

  Future<SerialResponse> bleRestore({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_restore(port_),
      parseSuccessData: _wire2api_serial_response,
      constMeta: kBleRestoreConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kBleRestoreConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ble_restore",
        argNames: [],
      );

  Future<SerialResponse> bleReboot({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ble_reboot(port_),
      parseSuccessData: _wire2api_serial_response,
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

  Future<bool> halNewControl(
      {required String id,
      required int retry,
      required int index,
      required int scene,
      required Com comIn,
      required Com comOut,
      dynamic hint}) {
    var arg0 = _platform.api2wire_String(id);
    var arg1 = api2wire_u8(retry);
    var arg2 = api2wire_u8(index);
    var arg3 = api2wire_u8(scene);
    var arg4 = _platform.api2wire_box_autoadd_com(comIn);
    var arg5 = _platform.api2wire_box_autoadd_com(comOut);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner
          .wire_hal_new_control(port_, arg0, arg1, arg2, arg3, arg4, arg5),
      parseSuccessData: _wire2api_bool,
      constMeta: kHalNewControlConstMeta,
      argValues: [id, retry, index, scene, comIn, comOut],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalNewControlConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_new_control",
        argNames: ["id", "retry", "index", "scene", "comIn", "comOut"],
      );

  Future<Com> halNewCom({required int value, dynamic hint}) {
    var arg0 = api2wire_u32(value);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_hal_new_com(port_, arg0),
      parseSuccessData: _wire2api_com,
      constMeta: kHalNewComConstMeta,
      argValues: [value],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalNewComConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_new_com",
        argNames: ["value"],
      );

  Future<Com> halGetComIndexs({required Uint8List indexs, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(indexs);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_hal_get_com_indexs(port_, arg0),
      parseSuccessData: _wire2api_com,
      constMeta: kHalGetComIndexsConstMeta,
      argValues: [indexs],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalGetComIndexsConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_get_com_indexs",
        argNames: ["indexs"],
      );

  Future<LogicControl?> halReadLogicControl(
      {required String id,
      required int retry,
      required int index,
      dynamic hint}) {
    var arg0 = _platform.api2wire_String(id);
    var arg1 = api2wire_u8(retry);
    var arg2 = api2wire_u8(index);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_hal_read_logic_control(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_opt_box_autoadd_logic_control,
      constMeta: kHalReadLogicControlConstMeta,
      argValues: [id, retry, index],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kHalReadLogicControlConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "hal_read_logic_control",
        argNames: ["id", "retry", "index"],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  String _wire2api_String(dynamic raw) {
    return raw as String;
  }

  bool _wire2api_bool(dynamic raw) {
    return raw as bool;
  }

  LogicControl _wire2api_box_autoadd_logic_control(dynamic raw) {
    return _wire2api_logic_control(raw);
  }

  int _wire2api_box_autoadd_u16(dynamic raw) {
    return raw as int;
  }

  Com _wire2api_com(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 1)
      throw Exception('unexpected arr length: expect 1 but see ${arr.length}');
    return Com(
      field0: _wire2api_u32(arr[0]),
    );
  }

  int _wire2api_i32(dynamic raw) {
    return raw as int;
  }

  LogicControl _wire2api_logic_control(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 4)
      throw Exception('unexpected arr length: expect 4 but see ${arr.length}');
    return LogicControl(
      index: _wire2api_u8(arr[0]),
      scene: _wire2api_u8(arr[1]),
      comIn: _wire2api_com(arr[2]),
      comOut: _wire2api_com(arr[3]),
    );
  }

  LogicControl? _wire2api_opt_box_autoadd_logic_control(dynamic raw) {
    return raw == null ? null : _wire2api_box_autoadd_logic_control(raw);
  }

  int? _wire2api_opt_box_autoadd_u16(dynamic raw) {
    return raw == null ? null : _wire2api_box_autoadd_u16(raw);
  }

  Uint8List? _wire2api_opt_uint_8_list(dynamic raw) {
    return raw == null ? null : _wire2api_uint_8_list(raw);
  }

  ResponseState _wire2api_response_state(dynamic raw) {
    return ResponseState.values[raw];
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

  int _wire2api_u16(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }
}

// Section: api2wire

@protected
int api2wire_u16(int raw) {
  return raw;
}

@protected
int api2wire_u32(int raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class NativePlatform extends FlutterRustBridgeBase<NativeWire> {
  NativePlatform(ffi.DynamicLibrary dylib) : super(NativeWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_Com> api2wire_box_autoadd_com(Com raw) {
    final ptr = inner.new_box_autoadd_com_0();
    _api_fill_to_wire_com(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire

  void _api_fill_to_wire_box_autoadd_com(
      Com apiObj, ffi.Pointer<wire_Com> wireObj) {
    _api_fill_to_wire_com(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_com(Com apiObj, wire_Com wireObj) {
    wireObj.field0 = api2wire_u32(apiObj.field0);
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class NativeWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_ble_validate_response(
    int port_,
    ffi.Pointer<wire_uint_8_list> data,
  ) {
    return _wire_ble_validate_response(
      port_,
      data,
    );
  }

  late final _wire_ble_validate_responsePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_ble_validate_response');
  late final _wire_ble_validate_response = _wire_ble_validate_responsePtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_ble_response_parse_u16(
    int port_,
    ffi.Pointer<wire_uint_8_list> data,
    int unit_id,
  ) {
    return _wire_ble_response_parse_u16(
      port_,
      data,
      unit_id,
    );
  }

  late final _wire_ble_response_parse_u16Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Uint8)>>('wire_ble_response_parse_u16');
  late final _wire_ble_response_parse_u16 = _wire_ble_response_parse_u16Ptr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>, int)>();

  void wire_ble_get_ndid(
    int port_,
  ) {
    return _wire_ble_get_ndid(
      port_,
    );
  }

  late final _wire_ble_get_ndidPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_ble_get_ndid');
  late final _wire_ble_get_ndid =
      _wire_ble_get_ndidPtr.asFunction<void Function(int)>();

  void wire_ble_at_ndrpt(
    int port_,
    ffi.Pointer<wire_uint_8_list> id,
    ffi.Pointer<wire_uint_8_list> data,
    int retry,
  ) {
    return _wire_ble_at_ndrpt(
      port_,
      id,
      data,
      retry,
    );
  }

  late final _wire_ble_at_ndrptPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>, ffi.Uint8)>>('wire_ble_at_ndrpt');
  late final _wire_ble_at_ndrpt = _wire_ble_at_ndrptPtr.asFunction<
      void Function(int, ffi.Pointer<wire_uint_8_list>,
          ffi.Pointer<wire_uint_8_list>, int)>();

  void wire_ble_at_ndrpt_data(
    int port_,
    ffi.Pointer<wire_uint_8_list> id,
    ffi.Pointer<wire_uint_8_list> data,
    int retry,
  ) {
    return _wire_ble_at_ndrpt_data(
      port_,
      id,
      data,
      retry,
    );
  }

  late final _wire_ble_at_ndrpt_dataPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Uint8)>>('wire_ble_at_ndrpt_data');
  late final _wire_ble_at_ndrpt_data = _wire_ble_at_ndrpt_dataPtr.asFunction<
      void Function(int, ffi.Pointer<wire_uint_8_list>,
          ffi.Pointer<wire_uint_8_list>, int)>();

  void wire_ble_at_ndrpt_test(
    int port_,
  ) {
    return _wire_ble_at_ndrpt_test(
      port_,
    );
  }

  late final _wire_ble_at_ndrpt_testPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_ble_at_ndrpt_test');
  late final _wire_ble_at_ndrpt_test =
      _wire_ble_at_ndrpt_testPtr.asFunction<void Function(int)>();

  void wire_ble_set_ndid(
    int port_,
    ffi.Pointer<wire_uint_8_list> id,
  ) {
    return _wire_ble_set_ndid(
      port_,
      id,
    );
  }

  late final _wire_ble_set_ndidPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_ble_set_ndid');
  late final _wire_ble_set_ndid = _wire_ble_set_ndidPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_ble_set_mode(
    int port_,
    int mode,
  ) {
    return _wire_ble_set_mode(
      port_,
      mode,
    );
  }

  late final _wire_ble_set_modePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Uint8)>>(
          'wire_ble_set_mode');
  late final _wire_ble_set_mode =
      _wire_ble_set_modePtr.asFunction<void Function(int, int)>();

  void wire_ble_ndreset(
    int port_,
  ) {
    return _wire_ble_ndreset(
      port_,
    );
  }

  late final _wire_ble_ndresetPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_ble_ndreset');
  late final _wire_ble_ndreset =
      _wire_ble_ndresetPtr.asFunction<void Function(int)>();

  void wire_ble_restore(
    int port_,
  ) {
    return _wire_ble_restore(
      port_,
    );
  }

  late final _wire_ble_restorePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_ble_restore');
  late final _wire_ble_restore =
      _wire_ble_restorePtr.asFunction<void Function(int)>();

  void wire_ble_reboot(
    int port_,
  ) {
    return _wire_ble_reboot(
      port_,
    );
  }

  late final _wire_ble_rebootPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_ble_reboot');
  late final _wire_ble_reboot =
      _wire_ble_rebootPtr.asFunction<void Function(int)>();

  void wire_hal_generate_get_holdings(
    int port_,
    int unit_id,
    int reg,
    int count,
  ) {
    return _wire_hal_generate_get_holdings(
      port_,
      unit_id,
      reg,
      count,
    );
  }

  late final _wire_hal_generate_get_holdingsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Uint8, ffi.Uint16,
              ffi.Uint16)>>('wire_hal_generate_get_holdings');
  late final _wire_hal_generate_get_holdings =
      _wire_hal_generate_get_holdingsPtr
          .asFunction<void Function(int, int, int, int)>();

  void wire_hal_generate_set_holding(
    int port_,
    int unit_id,
    int reg,
    int value,
  ) {
    return _wire_hal_generate_set_holding(
      port_,
      unit_id,
      reg,
      value,
    );
  }

  late final _wire_hal_generate_set_holdingPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Uint8, ffi.Uint16,
              ffi.Uint16)>>('wire_hal_generate_set_holding');
  late final _wire_hal_generate_set_holding = _wire_hal_generate_set_holdingPtr
      .asFunction<void Function(int, int, int, int)>();

  void wire_hex_encode(
    int port_,
    ffi.Pointer<wire_uint_8_list> data,
  ) {
    return _wire_hex_encode(
      port_,
      data,
    );
  }

  late final _wire_hex_encodePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_hex_encode');
  late final _wire_hex_encode = _wire_hex_encodePtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_hex_decode(
    int port_,
    ffi.Pointer<wire_uint_8_list> data,
  ) {
    return _wire_hex_decode(
      port_,
      data,
    );
  }

  late final _wire_hex_decodePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_hex_decode');
  late final _wire_hex_decode = _wire_hex_decodePtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_hal_new_control(
    int port_,
    ffi.Pointer<wire_uint_8_list> id,
    int retry,
    int index,
    int scene,
    ffi.Pointer<wire_Com> com_in,
    ffi.Pointer<wire_Com> com_out,
  ) {
    return _wire_hal_new_control(
      port_,
      id,
      retry,
      index,
      scene,
      com_in,
      com_out,
    );
  }

  late final _wire_hal_new_controlPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Uint8,
              ffi.Uint8,
              ffi.Uint8,
              ffi.Pointer<wire_Com>,
              ffi.Pointer<wire_Com>)>>('wire_hal_new_control');
  late final _wire_hal_new_control = _wire_hal_new_controlPtr.asFunction<
      void Function(int, ffi.Pointer<wire_uint_8_list>, int, int, int,
          ffi.Pointer<wire_Com>, ffi.Pointer<wire_Com>)>();

  void wire_hal_new_com(
    int port_,
    int value,
  ) {
    return _wire_hal_new_com(
      port_,
      value,
    );
  }

  late final _wire_hal_new_comPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Uint32)>>(
          'wire_hal_new_com');
  late final _wire_hal_new_com =
      _wire_hal_new_comPtr.asFunction<void Function(int, int)>();

  void wire_hal_get_com_indexs(
    int port_,
    ffi.Pointer<wire_uint_8_list> indexs,
  ) {
    return _wire_hal_get_com_indexs(
      port_,
      indexs,
    );
  }

  late final _wire_hal_get_com_indexsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_hal_get_com_indexs');
  late final _wire_hal_get_com_indexs = _wire_hal_get_com_indexsPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_hal_read_logic_control(
    int port_,
    ffi.Pointer<wire_uint_8_list> id,
    int retry,
    int index,
  ) {
    return _wire_hal_read_logic_control(
      port_,
      id,
      retry,
      index,
    );
  }

  late final _wire_hal_read_logic_controlPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>, ffi.Uint8,
              ffi.Uint8)>>('wire_hal_read_logic_control');
  late final _wire_hal_read_logic_control =
      _wire_hal_read_logic_controlPtr.asFunction<
          void Function(int, ffi.Pointer<wire_uint_8_list>, int, int)>();

  ffi.Pointer<wire_Com> new_box_autoadd_com_0() {
    return _new_box_autoadd_com_0();
  }

  late final _new_box_autoadd_com_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_Com> Function()>>(
          'new_box_autoadd_com_0');
  late final _new_box_autoadd_com_0 =
      _new_box_autoadd_com_0Ptr.asFunction<ffi.Pointer<wire_Com> Function()>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_8_list> Function(
              ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

class _Dart_Handle extends ffi.Opaque {}

class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

class wire_Com extends ffi.Struct {
  @ffi.Uint32()
  external int field0;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
