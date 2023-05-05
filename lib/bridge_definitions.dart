// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.75.1.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

abstract class Native {
  Future<bool> bleValidateResponse({required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleValidateResponseConstMeta;

  Future<int?> bleResponseParseU16(
      {required Uint8List data, required int unitId, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleResponseParseU16ConstMeta;

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

  Future<SerialResponse> bleLecconn2(
      {required String addr, required int addType, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLecconn2ConstMeta;

  Future<SerialResponse> bleLesend(
      {required int index, required String data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLesendConstMeta;

  Future<SerialResponse> bleChinfo({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleChinfoConstMeta;

  Future<String> halGenerateGetHoldings(
      {required int unitId,
      required int reg,
      required int count,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateGetHoldingsConstMeta;

  Future<String> halGenerateSetHolding(
      {required int unitId,
      required int reg,
      required int value,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGenerateSetHoldingConstMeta;

  Future<String> hexEncode({required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHexEncodeConstMeta;

  Future<Uint8List> hexDecode({required String data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHexDecodeConstMeta;

  Future<bool> halNewControl(
      {required String id,
      required int retry,
      required int index,
      required int scene,
      required Com comIn,
      required Com comOut,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalNewControlConstMeta;

  Future<Com> halNewCom({required int value, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalNewComConstMeta;

  Future<Com> halGetComIndexs({required Uint8List indexs, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalGetComIndexsConstMeta;

  Future<LogicControl?> halReadLogicControl(
      {required String id,
      required int retry,
      required int index,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalReadLogicControlConstMeta;
}

class Com {
  final int field0;

  const Com({
    required this.field0,
  });
}

class LogicControl {
  final int index;
  final int scene;
  final Com comIn;
  final Com comOut;

  const LogicControl({
    required this.index,
    required this.scene,
    required this.comIn,
    required this.comOut,
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
