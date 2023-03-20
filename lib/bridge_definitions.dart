// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.71.1.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

abstract class Native {
  Future<Uint8List> getNdid({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetNdidConstMeta;

  Future<Uint8List> atNdrpt(
      {required String id, required String data, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kAtNdrptConstMeta;

  Future<Uint8List> atNdrptTest({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kAtNdrptTestConstMeta;

  Future<Uint8List> setNdid({required String id, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kSetNdidConstMeta;

  Future<Uint8List> ndreset({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kNdresetConstMeta;

  Future<Uint8List> restore({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kRestoreConstMeta;

  Future<Uint8List> reboot({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kRebootConstMeta;

  Future<String> printA({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kPrintAConstMeta;
}