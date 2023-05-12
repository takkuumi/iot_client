// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.75.3.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

abstract class Native {
  Future<bool> bleValidateResponse({required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleValidateResponseConstMeta;

  Future<Uint16List?> bleResponseParseU16(
      {required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleResponseParseU16ConstMeta;

  Future<Uint8List?> bleResponseParseBool(
      {required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleResponseParseBoolConstMeta;

  Future<SerialResponse> bleGetNdid({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleGetNdidConstMeta;

  Future<SerialResponse> bleAtNdrpt(
      {required String id,
      required String data,
      required int retry,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleAtNdrptConstMeta;

  Future<SerialResponse> bleAtNdrptData(
      {required String id,
      required String data,
      required int retry,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleAtNdrptDataConstMeta;

  Future<SerialResponse> bleAtNdrptTest({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleAtNdrptTestConstMeta;

  Future<SerialResponse> bleSetNdid({required String id, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleSetNdidConstMeta;

  Future<SerialResponse> bleSetMode({required int mode, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleSetModeConstMeta;

  Future<SerialResponse> bleNdreset({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleNdresetConstMeta;

  Future<SerialResponse> bleRestore({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleRestoreConstMeta;

  Future<SerialResponse> bleReboot({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleRebootConstMeta;

  Future<SerialResponse> bleScan({required int typee, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleScanConstMeta;

  Future<SerialResponse> bleLecconn(
      {required String addr, required int addType, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLecconnConstMeta;

  Future<SerialResponse> bleLecconnAddr({required String addr, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLecconnAddrConstMeta;

  Future<SerialResponse> bleLedisc({required int index, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLediscConstMeta;

  Future<SerialResponse> bleLesend(
      {required int index, required String data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLesendConstMeta;

  Future<SerialResponse> bleChinfo({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleChinfoConstMeta;

  Future<SerialResponse> bleUartcfg({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleUartcfgConstMeta;

  Future<String> halGenerateGetHoldings(
      {required int unitId,
      required int reg,
      required int count,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateGetHoldingsConstMeta;

  Future<String> halGenerateGetCoils(
      {required int unitId,
      required int reg,
      required int count,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateGetCoilsConstMeta;

  Future<String> halGenerateSetCoils(
      {required int unitId,
      required int reg,
      required Uint8List values,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetCoilsConstMeta;

  Future<String> halGenerateSetCoil(
      {required int unitId,
      required int reg,
      required int value,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetCoilConstMeta;

  Future<String> halGenerateSetHolding(
      {required int unitId,
      required int reg,
      required int value,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetHoldingConstMeta;

  Future<String> halGenerateSetHoldingsBulk(
      {required int unitId,
      required int reg,
      required Uint16List values,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetHoldingsBulkConstMeta;

  Future<String> hexEncode({required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHexEncodeConstMeta;

  Future<Uint8List> hexDecode({required String data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHexDecodeConstMeta;

  Future<LogicControl> halNewLogicControl(
      {required int index,
      required int scene,
      required Uint8List values,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalNewLogicControlConstMeta;

  Future<String> halGenerateSetLcHoldings(
      {required int unitId, required LogicControl logicControl, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetLcHoldingsConstMeta;

  Future<Uint8List> convertU16SToU8S({required Uint16List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kConvertU16SToU8SConstMeta;
}

class LogicControl {
  final int index;
  final int scene;
  final Uint8List values;

  const LogicControl({
    required this.index,
    required this.scene,
    required this.values,
  });
}

enum ResponseState {
  Ok,
  FailedOpenDevice,
  Timeout,
  Unknown,
  MaxRetry,
  MaxSendRetry,
  ReadResponseError,
}

class SerialResponse {
  final ResponseState state;
  final Uint8List? data;

  const SerialResponse({
    required this.state,
    this.data,
  });
}
