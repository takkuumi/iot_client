import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iot_client/ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

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

Map<int, String> _comout = Map.from({
  -1: "无",
  0: "Q1(512)",
  1: "Q2(513)",
  2: "Q3(514)",
  3: "Q4(515)",
  4: "Q5(516)",
  5: "Q6(517)",
  6: "Q7(518)",
  7: "Q8(519)",
  8: "Q9(510)",
  9: "Q10(9)",
  10: "Q11(10)",
  11: "Q12(11)",
  12: "Q13(12)",
  13: "Q14(13)",
  14: "Q15(14)",
  15: "Q16(15)",
});

Map<int, String> _comin = Map.from({
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

class LogicRule {
  int index;
  int rule;
  List<List<int>> comIn;
  List<List<int>> comOut;
  List<Directive> directives;

  LogicRule({
    required this.index,
    required this.comIn,
    required this.comOut,
    this.rule = 0,
    this.directives = const [],
  }) {
    comIn.forEach((element) {
      debugPrint("=>${element.toString()}");
    });
  }
}

class LogicRuleItem extends StatefulWidget {
  const LogicRuleItem(
      {Key? key, required this.logicRule, required this.onRemoved})
      : super(key: key);
  final LogicRule logicRule;
  final void Function() onRemoved;
  @override
  State<LogicRuleItem> createState() => _LogicRuleItemState();
}

class _LogicRuleItemState extends State<LogicRuleItem> {
  int getWidgetIndex() {
    return widget.logicRule.index;
  }

  void submitRule(int? value) {
    if (value != null) {
      widget.logicRule.rule = value;
      setState(() {});
    }
  }

  void submitComin(int rowIndex, int itemIndex, int? value) async {
    if (value != null) {
      widget.logicRule.comIn[rowIndex][itemIndex] = value;
      setState(() {});
    }
  }

  void submitComout(int rowIndex, int itemIndex, int? value) async {
    if (value != null) {
      debugPrint(
          "submitComout=>rowIndex:$rowIndex itemIndex:$itemIndex value:$value");
      widget.logicRule.comOut[rowIndex][itemIndex] = value;
      widget.logicRule.comOut.forEach((element) {
        debugPrint("submitComout=>${element.toString()}");
      });
      setState(() {});
    }
  }

  int getComin(int rowIndex, int index) {
    return widget.logicRule.comIn[rowIndex][index];
  }

  int getComout(int rowIndex, int index) {
    return widget.logicRule.comOut[rowIndex][index];
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

  Widget buildCominItem(int rowIndex, String label, int index) {
    return Container(
      child: Column(
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
            value: getComout(rowIndex, index),
            items: genDropdownItems(_comout),
            onChanged: (value) {
              submitComout(rowIndex, index, value);
            },
          ),
          DropdownButton<int>(
            alignment: Alignment.center,
            value: getComin(rowIndex, index),
            items: genDropdownItems(_comin),
            onChanged: (value) {
              submitComin(rowIndex, index, value);
            },
          ),
        ],
      ),
    );
  }

  Widget buildWidget() {
    int rule = widget.logicRule.rule;
    if ([1, 2, 4, 6, 8].contains(rule)) {
      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCominItem(0, "正面绿箭", 0),
                buildCominItem(0, "正面红叉", 1),
                buildCominItem(0, "背面绿箭", 2),
                buildCominItem(0, "背面红叉", 3),
              ],
            ),
            buildSizedLine(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCominItem(1, "正面绿箭", 0),
                buildCominItem(1, "正面红叉", 1),
                buildCominItem(1, "背面绿箭", 2),
                buildCominItem(1, "背面红叉", 3),
              ],
            ),
          ],
        ),
      );
    } else if ([3, 5, 6, 7, 9].contains(rule)) {
      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCominItem(0, "正面绿箭", 0),
                buildCominItem(0, "正面红叉", 1),
                buildCominItem(0, "背面绿箭", 2),
                buildCominItem(0, "背面红叉", 3),
              ],
            ),
            buildSizedLine(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCominItem(1, "正面绿箭", 0),
                buildCominItem(1, "正面红叉", 1),
                buildCominItem(1, "背面绿箭", 2),
                buildCominItem(1, "背面红叉", 3),
              ],
            ),
            buildSizedLine(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCominItem(2, "正面绿箭", 0),
                buildCominItem(2, "正面红叉", 1),
                buildCominItem(2, "背面绿箭", 2),
                buildCominItem(2, "背面红叉", 3),
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    LogicRule logicRule = widget.logicRule;

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
                child: Text("逻辑角色寄存器${logicRule.index}"),
                color: Colors.blueAccent,
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
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
                  value: logicRule.rule,
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

  List<LogicRule> rules = [];
  List<GlobalKey<_LogicRuleItemState>> keys = [];

  final List<int> cominit = [
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1
  ];
  void addLogicRule() {
    rules.add(LogicRule(
      index: rules.length + 1,
      comIn: [List.from(cominit), List.from(cominit), List.from(cominit)],
      comOut: [List.from(cominit), List.from(cominit), List.from(cominit)],
    ));
    setState(() {});
  }

  void removeRule(int index) {
    rules.removeAt(index);
    rules.asMap().forEach((index, element) {
      element.index = index + 1;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (rules.isEmpty) {
      addLogicRule();
    }
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
            TextButton(
              onPressed: () => {
                // 保存逻辑配置
                keys.forEach((element) {
                  debugPrint("KEY ${element.currentState?.getWidgetIndex()}");
                })
              },
              child: Text("保存"),
            )
          ],
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: rules.length,
          itemBuilder: (ctxt, index) {
            final key = GlobalKey<_LogicRuleItemState>(
                debugLabel: "logic_rule_item$index");
            keys.add(key);

            return LogicRuleItem(
              key: key,
              logicRule: rules[index],
              onRemoved: () => removeRule(index),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addLogicRule,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
