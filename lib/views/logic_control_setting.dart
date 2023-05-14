import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iot_client/constants.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/model/logic.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<int, String> _rules = Map.from({
  0: "无（默认）",
  1: "单点控车指（4显）",
  2: "组合式车指（单面互锁；4显，反馈为独立点）",
  3: "组合式车指（单面互锁；6显，反馈为独立点）",
  4: "组合式车指（单面互锁；4显，反馈为组合点）",
  5: "组合式车指（单面互锁；6显，反馈为组合点）",
  6: "组合式车指（双面互锁；4显，反馈为独立点）",
  7: "组合式车指（双面互锁；6显，反馈为独立点）",
  8: "组合式车指（双面互锁；4显，反馈为组合点）",
  9: "组合式车指（双面互锁；6显，反馈为组合点）",
  10: "交通信号灯（4显）",
  11: "风机（3控制点，延时保护；互锁）",
  12: "风机（2控制点，延时保护；互锁）",
  13: "卷帘门（4控制点，点动信号）",
  14: "照明（单控制点）",
  15: "照明（双控制点）",
  16: "水泵（单控制点）",
  17: "风速风向",
  18: "COVI检测",
  19: "洞内光强",
  20: "洞外光照",
});

Map<int, String> _comQ = Map.from({
  -1: "无",
  0: "Q1(512)",
  1: "Q2(513)",
  2: "Q3(514)",
  3: "Q4(515)",
  4: "Q5(516)",
  5: "Q6(517)",
  6: "Q7(518)",
  7: "Q8(519)",
  8: "Q9(520)",
  9: "Q10(521)",
  10: "Q11(522)",
  11: "Q12(523)",
  12: "Q13(524)",
  13: "Q14(525)",
  14: "Q15(526)",
  15: "Q16(527)",
});

Map<int, String> _comI = Map.from({
  -1: "无",
  0: "I1(0)",
  1: "I2(1)",
  2: "I3(2)",
  3: "I4(3)",
  4: "I5(4)",
  5: "I6(5)",
  6: "I7(6)",
  7: "I8(7)",
  8: "I9(8)",
  9: "I10(9)",
  10: "I11(10)",
  11: "I12(11)",
  12: "I13(12)",
  13: "I14(13)",
  14: "I15(14)",
  15: "I16(15)",
});

Map<int, String> _kPortOptions = Map.from({
  0x01: "RS1",
  0x02: "RS2",
  0x03: "RS3",
});

Map<int, String> _kFunctionCodeOptions = Map.from({
  0x01: "读取线圈",
  0x02: "读取离散输入",
  0x03: "读取保持寄存器",
  0x04: "读取输入寄存器",
  0x05: "写单线圈",
  0x06: "写入单个寄存器",
  0x0F: "写入多个线圈",
  0x10: "写入多个寄存器",
});

List<DropdownMenuItem<int>> _ruleItems = _rules.keys
    .map((e) => DropdownMenuItem<int>(
          enabled: e <= 10,
          value: e,
          child: Text(_rules[e]!, style: TextStyle(fontSize: 14)),
        ))
    .toList();

List<DropdownMenuItem<int>> genDropdownItems(Map<int, String> options) {
  return options.keys
      .map((e) => DropdownMenuItem<int>(
            alignment: Alignment.center,
            value: e,
            child: Text(options[e]!, style: TextStyle(fontSize: 10)),
          ))
      .toList();
}

List<List<int>> _com = List.filled(3, List.filled(16, -1));

class Directive {
  int port;
  int functionCode;
  int slaveId;
  int slaveAddress;
  int count;
  int masterAddress;

  Directive({
    required this.port,
    required this.functionCode,
    required this.slaveId,
    required this.slaveAddress,
    required this.count,
    required this.masterAddress,
  });
}

class LogicRuleItem extends StatefulWidget {
  const LogicRuleItem(
      {Key? key, required this.logicRule, required this.onRemoved})
      : super(key: key);
  final Logic logicRule;
  final void Function() onRemoved;
  @override
  State<LogicRuleItem> createState() => _LogicRuleItemState();
}

class _LogicRuleItemState extends State<LogicRuleItem> {
  @override
  void dispose() {
    super.dispose();
  }

  int getWidgetIndex() {
    return widget.logicRule.index;
  }

  Logic getLogicRule() {
    return widget.logicRule;
  }

  void submitRule(int? value) {
    if (value != null) {
      widget.logicRule.scene = value;
      setState(() {});
    }
  }

  void submitCom(int itemIndex, int? value) async {
    debugPrint("submitCom: ${widget.logicRule.values.join(',')}");
    if (value != null) {
      widget.logicRule.values[itemIndex] = value;
    }
  }

  Widget buildSizedLine(double space) {
    return Column(
      children: [
        SizedBox(height: space),
        Divider(height: 1),
        SizedBox(height: space),
      ],
    );
  }

  Widget buildComQItem(String label, int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
          DropdownButton<int>(
            alignment: Alignment.center,
            value: widget.logicRule.values[index],
            items: genDropdownItems(_comQ),
            onChanged: (value) {
              setState(() {
                submitCom(index, value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildComQColumnItem(String label, int index) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
          DropdownButton<int>(
            alignment: Alignment.center,
            value: widget.logicRule.values[index],
            items: genDropdownItems(_comQ),
            onChanged: (value) {
              setState(() {
                submitCom(index, value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildComIItem(String label, int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
          DropdownButton<int>(
            alignment: Alignment.center,
            value: widget.logicRule.values[index],
            items: genDropdownItems(_comI),
            onChanged: (value) {
              setState(() {
                submitCom(index, value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildComIColumnItem(String label, int index) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ),
          DropdownButton<int>(
            alignment: Alignment.center,
            value: widget.logicRule.values[index],
            items: genDropdownItems(_comI),
            onChanged: (value) {
              setState(() {
                submitCom(index, value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildRow2() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQItem("正面绿箭", 0),
              buildComQItem("正面红叉", 1),
              buildComIItem("反馈点", 2),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQItem("背面绿箭", 3),
              buildComQItem("背面红叉", 4),
              buildComIItem("反馈点", 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRow() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQItem("正面绿箭", 0),
              buildComQItem("正面红叉", 1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQItem("背面绿箭", 2),
              buildComQItem("背面红叉", 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRow3() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQColumnItem("正面绿箭", 0),
              buildComQColumnItem("正面红叉", 1),
              buildComQColumnItem("正面右转", 2),
              buildComQColumnItem("反馈点", 3),
              buildComQColumnItem("反馈点", 4),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQColumnItem("背面绿箭", 5),
              buildComQColumnItem("背面红叉", 6),
              buildComQColumnItem("背面右转", 7),
              buildComQColumnItem("反馈点", 8),
              buildComQColumnItem("反馈点", 9),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildWidget() {
    int scene = widget.logicRule.scene;
    if (scene == 1) {
      return Container(
        child: Column(
          children: [
            buildRow(),
          ],
        ),
      );
    } else if ([2, 4, 6, 8].contains(scene)) {
      return Container(
        child: Column(
          children: [
            buildRow2(),
          ],
        ),
      );
    } else if ([3, 5, 7, 9].contains(scene)) {
      return Container(
        child: Column(
          children: [
            buildRow3(),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Logic logicRule = widget.logicRule;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 40,
                alignment: Alignment.center,
                child: Text("逻辑角色寄存器${logicRule.index + 1}"),
                color: Colors.blueAccent,
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(Symbols.close, color: Colors.white),
                  onPressed: widget.onRemoved,
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 5, 30, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("设置控制对象${logicRule.index}",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                DropdownButton<int>(
                  alignment: Alignment.bottomLeft,
                  value: logicRule.scene,
                  onChanged: submitRule,
                  items: _ruleItems,
                ),
              ],
            ),
          ),
          buildWidget(),
        ],
      ),
    );
  }
}

class LogicControlSetting extends StatefulWidget {
  const LogicControlSetting({Key? key}) : super(key: key);

  @override
  State<LogicControlSetting> createState() => _LogicControlSettingState();
}

class _LogicControlSettingState extends State<LogicControlSetting> {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'logic_control_setting');

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Logic> rules = [];
  Map<String, GlobalKey<_LogicRuleItemState>> keys = {};

  final List<int> cominit = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
  void addLogicRule() {
    int index = rules.length;
    rules.add(Logic(
      index: index,
      scene: 0,
      values: List.from(cominit),
    ));
  }

  void removeRule(int index) {
    rules.removeAt(index);
    final debugLabel = "logic_rule_item_$index";
    keys.remove(debugLabel);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        List<Logic> logics = await readLogicControlSetting();

        if (logics.isEmpty) {
          addLogicRule();
        } else {
          rules.clear();
          rules = logics;
        }

        setState(() {});
      } catch (err) {
        showSnackBar(err.toString());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('逻辑控制配置'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: '导入',
              icon: const Icon(Symbols.arrow_upward),
              onPressed: () {},
            ),
            IconButton(
              tooltip: '导出',
              icon: const Icon(Symbols.arrow_downward),
              onPressed: () {},
            ),
            IconButton(
              tooltip: '保存',
              icon: const Icon(Symbols.save),
              onPressed: () async {
                if (keys.length > 10) {
                  return showSnackBar("已达到最大逻辑数量", key);
                }
                final SharedPreferences prefs = await _prefs;
                int? index = prefs.getInt("no");
                if (index == null) {
                  throw Exception("未设置连接");
                }

                String? mac = prefs.getString("mac");
                if (mac == null) {
                  throw Exception("未设置连接");
                }
                // 保存逻辑配置
                final elements = keys.values
                    .where((source) => source.currentState != null)
                    .toList();

                List<Logic> saved = [];
                for (var element in elements) {
                  final logic = element.currentState?.getLogicRule();
                  if (logic != null) {
                    bool res = await logic.toLogicControl(index);
                    if (res) {
                      saved.add(logic);
                    }
                  }
                }

                if (saved.isEmpty) {
                  return showSnackBar("未设置逻辑", key);
                }
                saved.sort((a, b) => a.index.compareTo(b.index));
                String data = saved.map((e) => e.toList().join(',')).join(',');

                debugPrint("=+++++++++++++++++++++++++++   $data");
                await prefs.setString(mac, data);
                showSnackBar("保存成功", key);
              },
            )
          ],
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: rules.length,
          itemBuilder: (ctxt, index) {
            final debugLabel = "logic_rule_item_$index";
            debugPrint(debugLabel);
            final key = GlobalKey<_LogicRuleItemState>(debugLabel: debugLabel);
            keys.remove(debugLabel);

            keys.putIfAbsent(debugLabel, () => key);

            return LogicRuleItem(
              key: key,
              logicRule: rules[index],
              onRemoved: () => removeRule(index),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addLogicRule();
            setState(() {});
          },
          child: const Icon(Symbols.add),
        ),
      ),
    );
  }
}
