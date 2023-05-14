import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/model/port.dart';
import 'package:iot_client/provider/app_provider.dart';
import 'package:iot_client/scenes/widgets/util.dart';

final BoxShadow boxShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.5),
  spreadRadius: 5,
  blurRadius: 7,
  offset: const Offset(0, 3),
);

final Color disableColor = const Color.fromRGBO(221, 221, 221, 1);

typedef FutureCallback = Future<void> Function();

enum FanStat { r, b, s }

class FanUI extends StatefulHookConsumerWidget {
  final String title;
  final Port port;

  const FanUI({Key? key, required this.title, required this.port})
      : super(key: key);

  @override
  FanUIState createState() => FanUIState();
}

class FanUIState extends ConsumerState<FanUI> {
  FanStat stat = FanStat.s;
  bool isRemote = false;

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
      ref.watch(appReadWriteCoilsProvider.notifier).addListener((state) {
        if (mounted) {
          List<bool> coils = ref.read(appReadCoilsProvider);
          if (coils.isNotEmpty && state.isNotEmpty) {
            updateState(coils, state);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refresh() async {
    try {
      List<bool>? rCoils = await getCoils(0, 24);
      if (rCoils != null) {
        ref.read(appReadCoilsProvider.notifier).change(rCoils);
      }
      List<bool>? rwCoils = await getCoils(512, 24);
      if (rwCoils != null) {
        ref.read(appReadWriteCoilsProvider.notifier).change(rwCoils);
      }
    } catch (err) {
      EasyLoading.showError(err.toString());
    }
  }

  Future<void> updateState(List<bool> rCoils, List<bool> rwCoils) async {
    int sence = widget.port.getSence;
    debugPrint("updateState: $sence");
    if (11 != sence) {
      return;
    }

    bool st1 = rCoils[widget.port.p3];
    bool st2 = rCoils[widget.port.p4];
    bool st3 = rCoils[widget.port.p5];
    isRemote = rCoils[widget.port.p6];

    if (st1) {
      stat = FanStat.r;
    }

    if (st2) {
      stat = FanStat.b;
    }

    if (st3) {
      stat = FanStat.s;
    }

    setState(() {});
  }

  Widget createFanIcon() {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: Colors.greenAccent,
        ),
        borderRadius: BorderRadius.circular(75),
        boxShadow: [boxShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/icons/fan_icon.png",
            width: 80,
            height: 80,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 14),
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.greenAccent,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          createFanIcon(),
          Container(height: 15),
          createSig('远程信号:', isRemote ? '远程' : '本地'),
          createSig('正转信号:', stat == FanStat.r ? '正转' : '无'),
          createSig('反转信号:', stat == FanStat.b ? '反转' : '无'),
          createSig('停止信号:', stat == FanStat.s ? '停止' : '无'),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 20,
              children: [
                ElevatedButton(
                  child: Text("正转"),
                  onPressed: () async {
                    debugPrint(".............port 0 : ${widget.port.getP0}");
                    debugPrint(".............port 1 : ${widget.port.getP1}");
                    debugPrint(".............port 2: ${widget.port.getP2}");
                    await setCoil(widget.port.getP0, true);
                    await setCoil(widget.port.getP1, false);
                    await setCoil(widget.port.getP2, false);
                    await refresh();
                  },
                ),
                ElevatedButton(
                  child: Text("反转"),
                  onPressed: () async {
                    await setCoil(widget.port.getP0, false);
                    await setCoil(widget.port.getP1, true);
                    await setCoil(widget.port.getP2, false);
                    await refresh();
                  },
                ),
                ElevatedButton(
                  child: Text("停止"),
                  onPressed: () async {
                    await setCoil(widget.port.getP0, false);
                    await setCoil(widget.port.getP1, false);
                    await setCoil(widget.port.getP2, true);
                    await refresh();
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
