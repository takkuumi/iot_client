// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.75.1.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

abstract class Native {
  Future<SerialResponse> getNdid({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetNdidConstMeta;

  Future<SerialResponse> atNdrpt(
      {required String id, required String data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kAtNdrptConstMeta;

  Future<SerialResponse> atNdrptTest({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kAtNdrptTestConstMeta;

  Future<SerialResponse> setNdid({required String id, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kSetNdidConstMeta;

  Future<SerialResponse> setMode({required int mode, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kSetModeConstMeta;

  Future<SerialResponse> ndreset({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kNdresetConstMeta;

  Future<SerialResponse> restore({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kRestoreConstMeta;

  Future<SerialResponse> reboot({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kRebootConstMeta;

  Future<String> printA({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kPrintAConstMeta;
}

enum ResponseState {
  Ok,
  FailedOpenDevice,
  Timeout,
  Unknown,
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
