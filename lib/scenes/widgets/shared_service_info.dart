import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/constants.dart';
import 'package:iot_client/provider/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ffi.io.dart';

class SharedServiceInfo extends StatefulHookConsumerWidget {
  const SharedServiceInfo({Key? key}) : super(key: key);

  @override
  SharedServiceInfoState createState() => SharedServiceInfoState();
}

class SharedServiceInfoState extends ConsumerState<SharedServiceInfo> {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'light_outside');
  Future<DeviceDisplay?> serviceInfo = Future.value(null);

  Future<void> readHoldings1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? index = prefs.getInt("no");
    if (index == null) {
      return showSnackBar("未设置连接", key);
    }
    try {
      DeviceDisplay? deviceDisplay =
          await api.halReadDeviceSettings(index: index);

      if (deviceDisplay == null) {
        return showSnackBar("读取设备出错", key);
      }
      ref.read(deviceDisplayProvider.notifier).change(deviceDisplay);
    } catch (err) {
      debugPrint(err.toString());
      showSnackBar(err.toString());
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        ref.read(deviceDisplayProvider.notifier).addListener((deviceDisplay) {
          if (deviceDisplay != null) {
            serviceInfo = Future.value(deviceDisplay);
            setState(() {});
          }
        });
        DeviceDisplay? deviceDisplay = ref.read(deviceDisplayProvider);
        if (deviceDisplay != null) {
          serviceInfo = Future.value(deviceDisplay);
          setState(() {});
        }
        await readHoldings1().whenComplete(() {
          debugPrint("读取完成");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              verticalDirection: VerticalDirection.down,
              children: [
                Text(
                  "设备SN编号:",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox.fromSize(
                  size: Size(5, 0),
                ),
                FutureBuilder(
                  future: serviceInfo,
                  initialData: null,
                  builder: (context, AsyncSnapshot<DeviceDisplay?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data?.sn ?? '';
                      return Text(
                        id,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      );
                    }

                    return Text(
                      "",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              verticalDirection: VerticalDirection.down,
              children: [
                Text(
                  "设备状态:",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox.fromSize(
                  size: Size(5, 0),
                ),
                Text(
                  "运行中",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              verticalDirection: VerticalDirection.down,
              children: [
                Text(
                  "设备版本:",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox.fromSize(
                  size: Size(5, 0),
                ),
                Text(
                  "v1.0.0",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              verticalDirection: VerticalDirection.down,
              children: [
                Text(
                  "设备MAC地址:",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox.fromSize(
                  size: Size(5, 0),
                ),
                FutureBuilder(
                  future: serviceInfo,
                  initialData: null,
                  builder: (context, AsyncSnapshot<DeviceDisplay?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data?.mac ?? '';
                      return Text(
                        id,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      );
                    }

                    return Text(
                      "",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              verticalDirection: VerticalDirection.down,
              children: [
                Text(
                  "设备IP:",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox.fromSize(
                  size: Size(5, 0),
                ),
                FutureBuilder(
                  future: serviceInfo,
                  initialData: null,
                  builder: (context, AsyncSnapshot<DeviceDisplay?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data?.localIp ?? '';
                      return Text(
                        id,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      );
                    }

                    return Text(
                      "",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              verticalDirection: VerticalDirection.down,
              children: [
                Text(
                  "设备端口号:",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox.fromSize(
                  size: Size(5, 0),
                ),
                FutureBuilder(
                  future: serviceInfo,
                  initialData: null,
                  builder: (context, AsyncSnapshot<DeviceDisplay?> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      String id = snapshot.data?.localPort7.toString() ?? '';
                      return Text(
                        id,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      );
                    }

                    return Text(
                      "",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
