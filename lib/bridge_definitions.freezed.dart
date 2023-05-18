// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_definitions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Configuration {
  DataBit get dataBit => throw _privateConstructorUsedError;
  Parity get parity => throw _privateConstructorUsedError;
  StopBit get stopBit => throw _privateConstructorUsedError;
  BaudRate get baudRate => throw _privateConstructorUsedError;
  Undefine get undefine => throw _privateConstructorUsedError;
  PortType get portType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConfigurationCopyWith<Configuration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigurationCopyWith<$Res> {
  factory $ConfigurationCopyWith(
          Configuration value, $Res Function(Configuration) then) =
      _$ConfigurationCopyWithImpl<$Res, Configuration>;
  @useResult
  $Res call(
      {DataBit dataBit,
      Parity parity,
      StopBit stopBit,
      BaudRate baudRate,
      Undefine undefine,
      PortType portType});
}

/// @nodoc
class _$ConfigurationCopyWithImpl<$Res, $Val extends Configuration>
    implements $ConfigurationCopyWith<$Res> {
  _$ConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataBit = null,
    Object? parity = null,
    Object? stopBit = null,
    Object? baudRate = null,
    Object? undefine = null,
    Object? portType = null,
  }) {
    return _then(_value.copyWith(
      dataBit: null == dataBit
          ? _value.dataBit
          : dataBit // ignore: cast_nullable_to_non_nullable
              as DataBit,
      parity: null == parity
          ? _value.parity
          : parity // ignore: cast_nullable_to_non_nullable
              as Parity,
      stopBit: null == stopBit
          ? _value.stopBit
          : stopBit // ignore: cast_nullable_to_non_nullable
              as StopBit,
      baudRate: null == baudRate
          ? _value.baudRate
          : baudRate // ignore: cast_nullable_to_non_nullable
              as BaudRate,
      undefine: null == undefine
          ? _value.undefine
          : undefine // ignore: cast_nullable_to_non_nullable
              as Undefine,
      portType: null == portType
          ? _value.portType
          : portType // ignore: cast_nullable_to_non_nullable
              as PortType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ConfigurationCopyWith<$Res>
    implements $ConfigurationCopyWith<$Res> {
  factory _$$_ConfigurationCopyWith(
          _$_Configuration value, $Res Function(_$_Configuration) then) =
      __$$_ConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DataBit dataBit,
      Parity parity,
      StopBit stopBit,
      BaudRate baudRate,
      Undefine undefine,
      PortType portType});
}

/// @nodoc
class __$$_ConfigurationCopyWithImpl<$Res>
    extends _$ConfigurationCopyWithImpl<$Res, _$_Configuration>
    implements _$$_ConfigurationCopyWith<$Res> {
  __$$_ConfigurationCopyWithImpl(
      _$_Configuration _value, $Res Function(_$_Configuration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataBit = null,
    Object? parity = null,
    Object? stopBit = null,
    Object? baudRate = null,
    Object? undefine = null,
    Object? portType = null,
  }) {
    return _then(_$_Configuration(
      dataBit: null == dataBit
          ? _value.dataBit
          : dataBit // ignore: cast_nullable_to_non_nullable
              as DataBit,
      parity: null == parity
          ? _value.parity
          : parity // ignore: cast_nullable_to_non_nullable
              as Parity,
      stopBit: null == stopBit
          ? _value.stopBit
          : stopBit // ignore: cast_nullable_to_non_nullable
              as StopBit,
      baudRate: null == baudRate
          ? _value.baudRate
          : baudRate // ignore: cast_nullable_to_non_nullable
              as BaudRate,
      undefine: null == undefine
          ? _value.undefine
          : undefine // ignore: cast_nullable_to_non_nullable
              as Undefine,
      portType: null == portType
          ? _value.portType
          : portType // ignore: cast_nullable_to_non_nullable
              as PortType,
    ));
  }
}

/// @nodoc

class _$_Configuration implements _Configuration {
  const _$_Configuration(
      {required this.dataBit,
      required this.parity,
      required this.stopBit,
      required this.baudRate,
      required this.undefine,
      required this.portType});

  @override
  final DataBit dataBit;
  @override
  final Parity parity;
  @override
  final StopBit stopBit;
  @override
  final BaudRate baudRate;
  @override
  final Undefine undefine;
  @override
  final PortType portType;

  @override
  String toString() {
    return 'Configuration(dataBit: $dataBit, parity: $parity, stopBit: $stopBit, baudRate: $baudRate, undefine: $undefine, portType: $portType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Configuration &&
            (identical(other.dataBit, dataBit) || other.dataBit == dataBit) &&
            (identical(other.parity, parity) || other.parity == parity) &&
            (identical(other.stopBit, stopBit) || other.stopBit == stopBit) &&
            (identical(other.baudRate, baudRate) ||
                other.baudRate == baudRate) &&
            (identical(other.undefine, undefine) ||
                other.undefine == undefine) &&
            (identical(other.portType, portType) ||
                other.portType == portType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, dataBit, parity, stopBit, baudRate, undefine, portType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConfigurationCopyWith<_$_Configuration> get copyWith =>
      __$$_ConfigurationCopyWithImpl<_$_Configuration>(this, _$identity);
}

abstract class _Configuration implements Configuration {
  const factory _Configuration(
      {required final DataBit dataBit,
      required final Parity parity,
      required final StopBit stopBit,
      required final BaudRate baudRate,
      required final Undefine undefine,
      required final PortType portType}) = _$_Configuration;

  @override
  DataBit get dataBit;
  @override
  Parity get parity;
  @override
  StopBit get stopBit;
  @override
  BaudRate get baudRate;
  @override
  Undefine get undefine;
  @override
  PortType get portType;
  @override
  @JsonKey(ignore: true)
  _$$_ConfigurationCopyWith<_$_Configuration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeviceDisplay {
  String get sn => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  Setting get rs4851 => throw _privateConstructorUsedError;
  Setting get rs4852 => throw _privateConstructorUsedError;
  Setting get rs4853 => throw _privateConstructorUsedError;
  Setting get bt => throw _privateConstructorUsedError;
  Setting get net => throw _privateConstructorUsedError;
  int get localPort1 => throw _privateConstructorUsedError;
  int get localPort2 => throw _privateConstructorUsedError;
  int get localPort3 => throw _privateConstructorUsedError;
  int get localPort4 => throw _privateConstructorUsedError;
  int get localPort5 => throw _privateConstructorUsedError;
  int get localPort6 => throw _privateConstructorUsedError;
  int get localPort7 => throw _privateConstructorUsedError;
  int get localPort8 => throw _privateConstructorUsedError;
  String get localIp => throw _privateConstructorUsedError;
  String get subnetMask => throw _privateConstructorUsedError;
  String get gateway => throw _privateConstructorUsedError;
  String get dns => throw _privateConstructorUsedError;
  String get mac => throw _privateConstructorUsedError;
  int get remotePort => throw _privateConstructorUsedError;
  String get remoteIp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeviceDisplayCopyWith<DeviceDisplay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceDisplayCopyWith<$Res> {
  factory $DeviceDisplayCopyWith(
          DeviceDisplay value, $Res Function(DeviceDisplay) then) =
      _$DeviceDisplayCopyWithImpl<$Res, DeviceDisplay>;
  @useResult
  $Res call(
      {String sn,
      String location,
      Setting rs4851,
      Setting rs4852,
      Setting rs4853,
      Setting bt,
      Setting net,
      int localPort1,
      int localPort2,
      int localPort3,
      int localPort4,
      int localPort5,
      int localPort6,
      int localPort7,
      int localPort8,
      String localIp,
      String subnetMask,
      String gateway,
      String dns,
      String mac,
      int remotePort,
      String remoteIp});

  $SettingCopyWith<$Res> get rs4851;
  $SettingCopyWith<$Res> get rs4852;
  $SettingCopyWith<$Res> get rs4853;
  $SettingCopyWith<$Res> get bt;
  $SettingCopyWith<$Res> get net;
}

/// @nodoc
class _$DeviceDisplayCopyWithImpl<$Res, $Val extends DeviceDisplay>
    implements $DeviceDisplayCopyWith<$Res> {
  _$DeviceDisplayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sn = null,
    Object? location = null,
    Object? rs4851 = null,
    Object? rs4852 = null,
    Object? rs4853 = null,
    Object? bt = null,
    Object? net = null,
    Object? localPort1 = null,
    Object? localPort2 = null,
    Object? localPort3 = null,
    Object? localPort4 = null,
    Object? localPort5 = null,
    Object? localPort6 = null,
    Object? localPort7 = null,
    Object? localPort8 = null,
    Object? localIp = null,
    Object? subnetMask = null,
    Object? gateway = null,
    Object? dns = null,
    Object? mac = null,
    Object? remotePort = null,
    Object? remoteIp = null,
  }) {
    return _then(_value.copyWith(
      sn: null == sn
          ? _value.sn
          : sn // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      rs4851: null == rs4851
          ? _value.rs4851
          : rs4851 // ignore: cast_nullable_to_non_nullable
              as Setting,
      rs4852: null == rs4852
          ? _value.rs4852
          : rs4852 // ignore: cast_nullable_to_non_nullable
              as Setting,
      rs4853: null == rs4853
          ? _value.rs4853
          : rs4853 // ignore: cast_nullable_to_non_nullable
              as Setting,
      bt: null == bt
          ? _value.bt
          : bt // ignore: cast_nullable_to_non_nullable
              as Setting,
      net: null == net
          ? _value.net
          : net // ignore: cast_nullable_to_non_nullable
              as Setting,
      localPort1: null == localPort1
          ? _value.localPort1
          : localPort1 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort2: null == localPort2
          ? _value.localPort2
          : localPort2 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort3: null == localPort3
          ? _value.localPort3
          : localPort3 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort4: null == localPort4
          ? _value.localPort4
          : localPort4 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort5: null == localPort5
          ? _value.localPort5
          : localPort5 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort6: null == localPort6
          ? _value.localPort6
          : localPort6 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort7: null == localPort7
          ? _value.localPort7
          : localPort7 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort8: null == localPort8
          ? _value.localPort8
          : localPort8 // ignore: cast_nullable_to_non_nullable
              as int,
      localIp: null == localIp
          ? _value.localIp
          : localIp // ignore: cast_nullable_to_non_nullable
              as String,
      subnetMask: null == subnetMask
          ? _value.subnetMask
          : subnetMask // ignore: cast_nullable_to_non_nullable
              as String,
      gateway: null == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String,
      dns: null == dns
          ? _value.dns
          : dns // ignore: cast_nullable_to_non_nullable
              as String,
      mac: null == mac
          ? _value.mac
          : mac // ignore: cast_nullable_to_non_nullable
              as String,
      remotePort: null == remotePort
          ? _value.remotePort
          : remotePort // ignore: cast_nullable_to_non_nullable
              as int,
      remoteIp: null == remoteIp
          ? _value.remoteIp
          : remoteIp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingCopyWith<$Res> get rs4851 {
    return $SettingCopyWith<$Res>(_value.rs4851, (value) {
      return _then(_value.copyWith(rs4851: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingCopyWith<$Res> get rs4852 {
    return $SettingCopyWith<$Res>(_value.rs4852, (value) {
      return _then(_value.copyWith(rs4852: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingCopyWith<$Res> get rs4853 {
    return $SettingCopyWith<$Res>(_value.rs4853, (value) {
      return _then(_value.copyWith(rs4853: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingCopyWith<$Res> get bt {
    return $SettingCopyWith<$Res>(_value.bt, (value) {
      return _then(_value.copyWith(bt: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingCopyWith<$Res> get net {
    return $SettingCopyWith<$Res>(_value.net, (value) {
      return _then(_value.copyWith(net: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_DeviceDisplayCopyWith<$Res>
    implements $DeviceDisplayCopyWith<$Res> {
  factory _$$_DeviceDisplayCopyWith(
          _$_DeviceDisplay value, $Res Function(_$_DeviceDisplay) then) =
      __$$_DeviceDisplayCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sn,
      String location,
      Setting rs4851,
      Setting rs4852,
      Setting rs4853,
      Setting bt,
      Setting net,
      int localPort1,
      int localPort2,
      int localPort3,
      int localPort4,
      int localPort5,
      int localPort6,
      int localPort7,
      int localPort8,
      String localIp,
      String subnetMask,
      String gateway,
      String dns,
      String mac,
      int remotePort,
      String remoteIp});

  @override
  $SettingCopyWith<$Res> get rs4851;
  @override
  $SettingCopyWith<$Res> get rs4852;
  @override
  $SettingCopyWith<$Res> get rs4853;
  @override
  $SettingCopyWith<$Res> get bt;
  @override
  $SettingCopyWith<$Res> get net;
}

/// @nodoc
class __$$_DeviceDisplayCopyWithImpl<$Res>
    extends _$DeviceDisplayCopyWithImpl<$Res, _$_DeviceDisplay>
    implements _$$_DeviceDisplayCopyWith<$Res> {
  __$$_DeviceDisplayCopyWithImpl(
      _$_DeviceDisplay _value, $Res Function(_$_DeviceDisplay) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sn = null,
    Object? location = null,
    Object? rs4851 = null,
    Object? rs4852 = null,
    Object? rs4853 = null,
    Object? bt = null,
    Object? net = null,
    Object? localPort1 = null,
    Object? localPort2 = null,
    Object? localPort3 = null,
    Object? localPort4 = null,
    Object? localPort5 = null,
    Object? localPort6 = null,
    Object? localPort7 = null,
    Object? localPort8 = null,
    Object? localIp = null,
    Object? subnetMask = null,
    Object? gateway = null,
    Object? dns = null,
    Object? mac = null,
    Object? remotePort = null,
    Object? remoteIp = null,
  }) {
    return _then(_$_DeviceDisplay(
      sn: null == sn
          ? _value.sn
          : sn // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      rs4851: null == rs4851
          ? _value.rs4851
          : rs4851 // ignore: cast_nullable_to_non_nullable
              as Setting,
      rs4852: null == rs4852
          ? _value.rs4852
          : rs4852 // ignore: cast_nullable_to_non_nullable
              as Setting,
      rs4853: null == rs4853
          ? _value.rs4853
          : rs4853 // ignore: cast_nullable_to_non_nullable
              as Setting,
      bt: null == bt
          ? _value.bt
          : bt // ignore: cast_nullable_to_non_nullable
              as Setting,
      net: null == net
          ? _value.net
          : net // ignore: cast_nullable_to_non_nullable
              as Setting,
      localPort1: null == localPort1
          ? _value.localPort1
          : localPort1 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort2: null == localPort2
          ? _value.localPort2
          : localPort2 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort3: null == localPort3
          ? _value.localPort3
          : localPort3 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort4: null == localPort4
          ? _value.localPort4
          : localPort4 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort5: null == localPort5
          ? _value.localPort5
          : localPort5 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort6: null == localPort6
          ? _value.localPort6
          : localPort6 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort7: null == localPort7
          ? _value.localPort7
          : localPort7 // ignore: cast_nullable_to_non_nullable
              as int,
      localPort8: null == localPort8
          ? _value.localPort8
          : localPort8 // ignore: cast_nullable_to_non_nullable
              as int,
      localIp: null == localIp
          ? _value.localIp
          : localIp // ignore: cast_nullable_to_non_nullable
              as String,
      subnetMask: null == subnetMask
          ? _value.subnetMask
          : subnetMask // ignore: cast_nullable_to_non_nullable
              as String,
      gateway: null == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String,
      dns: null == dns
          ? _value.dns
          : dns // ignore: cast_nullable_to_non_nullable
              as String,
      mac: null == mac
          ? _value.mac
          : mac // ignore: cast_nullable_to_non_nullable
              as String,
      remotePort: null == remotePort
          ? _value.remotePort
          : remotePort // ignore: cast_nullable_to_non_nullable
              as int,
      remoteIp: null == remoteIp
          ? _value.remoteIp
          : remoteIp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_DeviceDisplay implements _DeviceDisplay {
  const _$_DeviceDisplay(
      {required this.sn,
      required this.location,
      required this.rs4851,
      required this.rs4852,
      required this.rs4853,
      required this.bt,
      required this.net,
      required this.localPort1,
      required this.localPort2,
      required this.localPort3,
      required this.localPort4,
      required this.localPort5,
      required this.localPort6,
      required this.localPort7,
      required this.localPort8,
      required this.localIp,
      required this.subnetMask,
      required this.gateway,
      required this.dns,
      required this.mac,
      required this.remotePort,
      required this.remoteIp});

  @override
  final String sn;
  @override
  final String location;
  @override
  final Setting rs4851;
  @override
  final Setting rs4852;
  @override
  final Setting rs4853;
  @override
  final Setting bt;
  @override
  final Setting net;
  @override
  final int localPort1;
  @override
  final int localPort2;
  @override
  final int localPort3;
  @override
  final int localPort4;
  @override
  final int localPort5;
  @override
  final int localPort6;
  @override
  final int localPort7;
  @override
  final int localPort8;
  @override
  final String localIp;
  @override
  final String subnetMask;
  @override
  final String gateway;
  @override
  final String dns;
  @override
  final String mac;
  @override
  final int remotePort;
  @override
  final String remoteIp;

  @override
  String toString() {
    return 'DeviceDisplay(sn: $sn, location: $location, rs4851: $rs4851, rs4852: $rs4852, rs4853: $rs4853, bt: $bt, net: $net, localPort1: $localPort1, localPort2: $localPort2, localPort3: $localPort3, localPort4: $localPort4, localPort5: $localPort5, localPort6: $localPort6, localPort7: $localPort7, localPort8: $localPort8, localIp: $localIp, subnetMask: $subnetMask, gateway: $gateway, dns: $dns, mac: $mac, remotePort: $remotePort, remoteIp: $remoteIp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DeviceDisplay &&
            (identical(other.sn, sn) || other.sn == sn) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.rs4851, rs4851) || other.rs4851 == rs4851) &&
            (identical(other.rs4852, rs4852) || other.rs4852 == rs4852) &&
            (identical(other.rs4853, rs4853) || other.rs4853 == rs4853) &&
            (identical(other.bt, bt) || other.bt == bt) &&
            (identical(other.net, net) || other.net == net) &&
            (identical(other.localPort1, localPort1) ||
                other.localPort1 == localPort1) &&
            (identical(other.localPort2, localPort2) ||
                other.localPort2 == localPort2) &&
            (identical(other.localPort3, localPort3) ||
                other.localPort3 == localPort3) &&
            (identical(other.localPort4, localPort4) ||
                other.localPort4 == localPort4) &&
            (identical(other.localPort5, localPort5) ||
                other.localPort5 == localPort5) &&
            (identical(other.localPort6, localPort6) ||
                other.localPort6 == localPort6) &&
            (identical(other.localPort7, localPort7) ||
                other.localPort7 == localPort7) &&
            (identical(other.localPort8, localPort8) ||
                other.localPort8 == localPort8) &&
            (identical(other.localIp, localIp) || other.localIp == localIp) &&
            (identical(other.subnetMask, subnetMask) ||
                other.subnetMask == subnetMask) &&
            (identical(other.gateway, gateway) || other.gateway == gateway) &&
            (identical(other.dns, dns) || other.dns == dns) &&
            (identical(other.mac, mac) || other.mac == mac) &&
            (identical(other.remotePort, remotePort) ||
                other.remotePort == remotePort) &&
            (identical(other.remoteIp, remoteIp) ||
                other.remoteIp == remoteIp));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        sn,
        location,
        rs4851,
        rs4852,
        rs4853,
        bt,
        net,
        localPort1,
        localPort2,
        localPort3,
        localPort4,
        localPort5,
        localPort6,
        localPort7,
        localPort8,
        localIp,
        subnetMask,
        gateway,
        dns,
        mac,
        remotePort,
        remoteIp
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DeviceDisplayCopyWith<_$_DeviceDisplay> get copyWith =>
      __$$_DeviceDisplayCopyWithImpl<_$_DeviceDisplay>(this, _$identity);
}

abstract class _DeviceDisplay implements DeviceDisplay {
  const factory _DeviceDisplay(
      {required final String sn,
      required final String location,
      required final Setting rs4851,
      required final Setting rs4852,
      required final Setting rs4853,
      required final Setting bt,
      required final Setting net,
      required final int localPort1,
      required final int localPort2,
      required final int localPort3,
      required final int localPort4,
      required final int localPort5,
      required final int localPort6,
      required final int localPort7,
      required final int localPort8,
      required final String localIp,
      required final String subnetMask,
      required final String gateway,
      required final String dns,
      required final String mac,
      required final int remotePort,
      required final String remoteIp}) = _$_DeviceDisplay;

  @override
  String get sn;
  @override
  String get location;
  @override
  Setting get rs4851;
  @override
  Setting get rs4852;
  @override
  Setting get rs4853;
  @override
  Setting get bt;
  @override
  Setting get net;
  @override
  int get localPort1;
  @override
  int get localPort2;
  @override
  int get localPort3;
  @override
  int get localPort4;
  @override
  int get localPort5;
  @override
  int get localPort6;
  @override
  int get localPort7;
  @override
  int get localPort8;
  @override
  String get localIp;
  @override
  String get subnetMask;
  @override
  String get gateway;
  @override
  String get dns;
  @override
  String get mac;
  @override
  int get remotePort;
  @override
  String get remoteIp;
  @override
  @JsonKey(ignore: true)
  _$$_DeviceDisplayCopyWith<_$_DeviceDisplay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ResponseState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() ok,
    required TResult Function(ErrorKind field0) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? ok,
    TResult? Function(ErrorKind field0)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? ok,
    TResult Function(ErrorKind field0)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResponseState_Ok value) ok,
    required TResult Function(ResponseState_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResponseState_Ok value)? ok,
    TResult? Function(ResponseState_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResponseState_Ok value)? ok,
    TResult Function(ResponseState_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseStateCopyWith<$Res> {
  factory $ResponseStateCopyWith(
          ResponseState value, $Res Function(ResponseState) then) =
      _$ResponseStateCopyWithImpl<$Res, ResponseState>;
}

/// @nodoc
class _$ResponseStateCopyWithImpl<$Res, $Val extends ResponseState>
    implements $ResponseStateCopyWith<$Res> {
  _$ResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ResponseState_OkCopyWith<$Res> {
  factory _$$ResponseState_OkCopyWith(
          _$ResponseState_Ok value, $Res Function(_$ResponseState_Ok) then) =
      __$$ResponseState_OkCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResponseState_OkCopyWithImpl<$Res>
    extends _$ResponseStateCopyWithImpl<$Res, _$ResponseState_Ok>
    implements _$$ResponseState_OkCopyWith<$Res> {
  __$$ResponseState_OkCopyWithImpl(
      _$ResponseState_Ok _value, $Res Function(_$ResponseState_Ok) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ResponseState_Ok implements ResponseState_Ok {
  const _$ResponseState_Ok();

  @override
  String toString() {
    return 'ResponseState.ok()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResponseState_Ok);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() ok,
    required TResult Function(ErrorKind field0) error,
  }) {
    return ok();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? ok,
    TResult? Function(ErrorKind field0)? error,
  }) {
    return ok?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? ok,
    TResult Function(ErrorKind field0)? error,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResponseState_Ok value) ok,
    required TResult Function(ResponseState_Error value) error,
  }) {
    return ok(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResponseState_Ok value)? ok,
    TResult? Function(ResponseState_Error value)? error,
  }) {
    return ok?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResponseState_Ok value)? ok,
    TResult Function(ResponseState_Error value)? error,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok(this);
    }
    return orElse();
  }
}

abstract class ResponseState_Ok implements ResponseState {
  const factory ResponseState_Ok() = _$ResponseState_Ok;
}

/// @nodoc
abstract class _$$ResponseState_ErrorCopyWith<$Res> {
  factory _$$ResponseState_ErrorCopyWith(_$ResponseState_Error value,
          $Res Function(_$ResponseState_Error) then) =
      __$$ResponseState_ErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({ErrorKind field0});
}

/// @nodoc
class __$$ResponseState_ErrorCopyWithImpl<$Res>
    extends _$ResponseStateCopyWithImpl<$Res, _$ResponseState_Error>
    implements _$$ResponseState_ErrorCopyWith<$Res> {
  __$$ResponseState_ErrorCopyWithImpl(
      _$ResponseState_Error _value, $Res Function(_$ResponseState_Error) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ResponseState_Error(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as ErrorKind,
    ));
  }
}

/// @nodoc

class _$ResponseState_Error implements ResponseState_Error {
  const _$ResponseState_Error(this.field0);

  @override
  final ErrorKind field0;

  @override
  String toString() {
    return 'ResponseState.error(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseState_Error &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseState_ErrorCopyWith<_$ResponseState_Error> get copyWith =>
      __$$ResponseState_ErrorCopyWithImpl<_$ResponseState_Error>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() ok,
    required TResult Function(ErrorKind field0) error,
  }) {
    return error(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? ok,
    TResult? Function(ErrorKind field0)? error,
  }) {
    return error?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? ok,
    TResult Function(ErrorKind field0)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResponseState_Ok value) ok,
    required TResult Function(ResponseState_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResponseState_Ok value)? ok,
    TResult? Function(ResponseState_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResponseState_Ok value)? ok,
    TResult Function(ResponseState_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ResponseState_Error implements ResponseState {
  const factory ResponseState_Error(final ErrorKind field0) =
      _$ResponseState_Error;

  ErrorKind get field0;
  @JsonKey(ignore: true)
  _$$ResponseState_ErrorCopyWith<_$ResponseState_Error> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Setting {
  Configuration get configuration => throw _privateConstructorUsedError;
  int get slaveAddr => throw _privateConstructorUsedError;
  int get retry => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  int get loopInterval => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingCopyWith<Setting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingCopyWith<$Res> {
  factory $SettingCopyWith(Setting value, $Res Function(Setting) then) =
      _$SettingCopyWithImpl<$Res, Setting>;
  @useResult
  $Res call(
      {Configuration configuration,
      int slaveAddr,
      int retry,
      int duration,
      int loopInterval});

  $ConfigurationCopyWith<$Res> get configuration;
}

/// @nodoc
class _$SettingCopyWithImpl<$Res, $Val extends Setting>
    implements $SettingCopyWith<$Res> {
  _$SettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configuration = null,
    Object? slaveAddr = null,
    Object? retry = null,
    Object? duration = null,
    Object? loopInterval = null,
  }) {
    return _then(_value.copyWith(
      configuration: null == configuration
          ? _value.configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as Configuration,
      slaveAddr: null == slaveAddr
          ? _value.slaveAddr
          : slaveAddr // ignore: cast_nullable_to_non_nullable
              as int,
      retry: null == retry
          ? _value.retry
          : retry // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      loopInterval: null == loopInterval
          ? _value.loopInterval
          : loopInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ConfigurationCopyWith<$Res> get configuration {
    return $ConfigurationCopyWith<$Res>(_value.configuration, (value) {
      return _then(_value.copyWith(configuration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SettingCopyWith<$Res> implements $SettingCopyWith<$Res> {
  factory _$$_SettingCopyWith(
          _$_Setting value, $Res Function(_$_Setting) then) =
      __$$_SettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Configuration configuration,
      int slaveAddr,
      int retry,
      int duration,
      int loopInterval});

  @override
  $ConfigurationCopyWith<$Res> get configuration;
}

/// @nodoc
class __$$_SettingCopyWithImpl<$Res>
    extends _$SettingCopyWithImpl<$Res, _$_Setting>
    implements _$$_SettingCopyWith<$Res> {
  __$$_SettingCopyWithImpl(_$_Setting _value, $Res Function(_$_Setting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configuration = null,
    Object? slaveAddr = null,
    Object? retry = null,
    Object? duration = null,
    Object? loopInterval = null,
  }) {
    return _then(_$_Setting(
      configuration: null == configuration
          ? _value.configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as Configuration,
      slaveAddr: null == slaveAddr
          ? _value.slaveAddr
          : slaveAddr // ignore: cast_nullable_to_non_nullable
              as int,
      retry: null == retry
          ? _value.retry
          : retry // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      loopInterval: null == loopInterval
          ? _value.loopInterval
          : loopInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_Setting implements _Setting {
  const _$_Setting(
      {required this.configuration,
      required this.slaveAddr,
      required this.retry,
      required this.duration,
      required this.loopInterval});

  @override
  final Configuration configuration;
  @override
  final int slaveAddr;
  @override
  final int retry;
  @override
  final int duration;
  @override
  final int loopInterval;

  @override
  String toString() {
    return 'Setting(configuration: $configuration, slaveAddr: $slaveAddr, retry: $retry, duration: $duration, loopInterval: $loopInterval)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Setting &&
            (identical(other.configuration, configuration) ||
                other.configuration == configuration) &&
            (identical(other.slaveAddr, slaveAddr) ||
                other.slaveAddr == slaveAddr) &&
            (identical(other.retry, retry) || other.retry == retry) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.loopInterval, loopInterval) ||
                other.loopInterval == loopInterval));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, configuration, slaveAddr, retry, duration, loopInterval);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingCopyWith<_$_Setting> get copyWith =>
      __$$_SettingCopyWithImpl<_$_Setting>(this, _$identity);
}

abstract class _Setting implements Setting {
  const factory _Setting(
      {required final Configuration configuration,
      required final int slaveAddr,
      required final int retry,
      required final int duration,
      required final int loopInterval}) = _$_Setting;

  @override
  Configuration get configuration;
  @override
  int get slaveAddr;
  @override
  int get retry;
  @override
  int get duration;
  @override
  int get loopInterval;
  @override
  @JsonKey(ignore: true)
  _$$_SettingCopyWith<_$_Setting> get copyWith =>
      throw _privateConstructorUsedError;
}
