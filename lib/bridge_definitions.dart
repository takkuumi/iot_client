// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.75.3.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;

part 'bridge_definitions.freezed.dart';

abstract class Native {
  Future<bool> bleValidateResponse({required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleValidateResponseConstMeta;

  Future<Uint16List?> bleResponseParseU16(
      {required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleResponseParseU16ConstMeta;

  Future<Uint8List?> bleResponseParseBool(
      {required Uint8List data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleResponseParseBoolConstMeta;

  Future<String> blePorts({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBlePortsConstMeta;

  Future<SerialResponse> bleScan({required int typee, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleScanConstMeta;

  Future<bool> bleLecconn(
      {required String addr, required int addType, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLecconnConstMeta;

  Future<bool> bleLedisc({required int index, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLediscConstMeta;

  Future<SerialResponse> bleLesend(
      {required int index, required String data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleLesendConstMeta;

  Future<void> bleTpmode({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleTpmodeConstMeta;

  Future<void> bleReboot({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kBleRebootConstMeta;

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

  Future<DeviceDisplay?> halReadDeviceSettings(
      {required int index, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kHalReadDeviceSettingsConstMeta;
}

enum BaudRate {
  BS300,
  BS600,
  BS1200,
  BS2400,
  BS4800,
  BS9600,
  BS19200,
  BS115200,
}

@freezed
class Configuration with _$Configuration {
  const factory Configuration({
    required DataBit dataBit,
    required Parity parity,
    required StopBit stopBit,
    required BaudRate baudRate,
    required Undefine undefine,
    required PortType portType,
  }) = _Configuration;
}

enum DataBit {
  BitWidth8,
  BitWidth9,
}

@freezed
class DeviceDisplay with _$DeviceDisplay {
  const factory DeviceDisplay({
    required String sn,
    required String location,
    required Setting rs4851,
    required Setting rs4852,
    required Setting rs4853,
    required Setting bt,
    required Setting net,
    required int localPort1,
    required int localPort2,
    required int localPort3,
    required int localPort4,
    required int localPort5,
    required int localPort6,
    required int localPort7,
    required int localPort8,
    required String localIp,
    required String subnetMask,
    required String gateway,
    required String dns,
    required String mac,
    required int remotePort,
    required String remoteIp,
  }) = _DeviceDisplay;
}

enum ErrorKind {
  FailedOpenDevice,
  Timeout,
  Unknown,
  FailedReadData,
  ReadResponseError,
  FailedWrite,
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

enum Parity {
  Nil,
  Odd,
  Even,
}

enum PortType {
  Nil,
  Master,
  Slave,
}

@freezed
class ResponseState with _$ResponseState {
  const factory ResponseState.ok() = ResponseState_Ok;
  const factory ResponseState.error(
    ErrorKind field0,
  ) = ResponseState_Error;
}

class SerialResponse {
  final ResponseState state;
  final Uint8List? data;

  const SerialResponse({
    required this.state,
    this.data,
  });
}

@freezed
class Setting with _$Setting {
  const factory Setting({
    required Configuration configuration,
    required int slaveAddr,
    required int retry,
    required int duration,
    required int loopInterval,
  }) = _Setting;
}

enum StopBit {
  Bit1,
  Bit2,
}

enum Undefine {
  Def,
}
