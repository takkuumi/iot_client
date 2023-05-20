import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iot_client/constants.dart';
import 'package:iot_client/futs/hal.dart';
import 'package:iot_client/model/logic.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<int, String> _rules = Map.from({
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
  // 12: "风机（2控制点，延时保护；互锁）",
  13: "卷帘门（3控制点，点动信号）",
  // 14: "照明（单控制点）",
  21: "横洞指示器（双控制点）",
  15: "照明（双控制点）",
  16: "水泵（单控制点）",
  17: "风速风向",
  18: "COVI检测",
  19: "洞内光强",
  20: "洞外光照",
});

final Map<int, String> _comQ = Map.from({
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

final Map<int, String> _comI = Map.from({
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
  0: "无",
  1: "RS1",
  2: "RS2",
  3: "RS3",
});

Map<int, String> _kFunctionCodeOptions = Map.from({
  0: "无",
  1: "读取线圈",
  2: "读取离散输入",
  3: "读取保持寄存器",
  4: "读取输入寄存器",
  5: "写单线圈",
  6: "写入单个寄存器",
  15: "写入多个线圈",
  16: "写入多个寄存器",
});

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
  final GlobalKey<FormState> _idForm = GlobalKey<FormState>();
  final GlobalKey<FormState> _masterAddrForm = GlobalKey<FormState>();
  final GlobalKey<FormState> _countForm = GlobalKey<FormState>();
  final GlobalKey<FormState> _slaveAddrForm = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _masterAddr = TextEditingController();
  final TextEditingController _count = TextEditingController();
  final TextEditingController _slaveAddr = TextEditingController();

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

  void changeScene(int? value) {
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

  final List<DropdownMenuItem<int>> _ruleItems = _rules.keys
      .map((e) => DropdownMenuItem<int>(
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

  Widget buildSizedLine(double space) {
    return Column(
      children: [
        SizedBox(height: space),
        Divider(height: 1),
        SizedBox(height: space),
      ],
    );
  }

  final labelStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.redAccent,
  );

  Widget buildComQItem(String label, int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: labelStyle),
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

  Widget buildPortItem(int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("端口号", style: labelStyle),
          DropdownButton<int>(
            alignment: Alignment.center,
            value: widget.logicRule.values[index],
            items: genDropdownItems(_kPortOptions),
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

  Widget buildFunctionCodeItem(int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("功能码", style: labelStyle),
          DropdownButton<int>(
            alignment: Alignment.center,
            value: widget.logicRule.values[index],
            items: genDropdownItems(_kFunctionCodeOptions),
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
          Text(label, style: labelStyle),
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
          Text(label, style: labelStyle),
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
          Text(label, style: labelStyle),
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

  Widget buildLaneIndicatorRow2() {
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

  Widget buildLaneIndicatorRow() {
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

  Widget buildLaneIndicatorRow3() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQColumnItem("正面绿箭", 0),
              buildComQColumnItem("正面红叉", 1),
              buildComQColumnItem("正面右转", 2),
              buildComIColumnItem("反馈点", 3),
              buildComIColumnItem("反馈点", 4),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQColumnItem("背面绿箭", 5),
              buildComQColumnItem("背面红叉", 6),
              buildComQColumnItem("背面右转", 7),
              buildComIColumnItem("反馈点", 8),
              buildComIColumnItem("反馈点", 9),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTrafficRow() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQColumnItem("左箭", 0),
              buildComQColumnItem("绿灯", 1),
              buildComQColumnItem("红灯", 2),
              buildComQColumnItem("黄灯", 3),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComIColumnItem("左箭反馈", 4),
              buildComIColumnItem("绿灯反馈", 5),
              buildComIColumnItem("红灯反馈", 6),
              buildComIColumnItem("黄灯反馈", 7),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFanRow() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQColumnItem("正转控制", 0),
              buildComQColumnItem("反转控制", 1),
              buildComQColumnItem("停止控制", 2),
              Container(width: 60),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComIColumnItem("正转反馈", 3),
              buildComIColumnItem("反转反馈", 4),
              buildComIColumnItem("停止反馈", 5),
              buildComIColumnItem("远程信号", 6),
            ],
          ),
        ],
      ),
    );
  }

  // Widget buildFanRow2() {
  //   return Container(
  //     child: Column(
  //       children: [],
  //     ),
  //   );
  // }

  Widget buildDoorRow() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComQColumnItem("开门控制", 0),
              buildComQColumnItem("关门控制", 1),
              buildComQColumnItem("停止控制", 2),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildComIColumnItem("开到位反馈", 3),
              buildComIColumnItem("关到位反馈", 4),
              buildComIColumnItem("故障反馈", 5),
            ],
          ),
        ],
      ),
    );
  }

  // Widget buildLightRow() {
  //   return Container(
  //     child: Column(
  //       children: [],
  //     ),
  //   );
  // }

  Widget buildLightRow2() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildComQColumnItem("开灯控制", 0),
          buildComQColumnItem("关灯控制", 1),
          buildComIColumnItem("远程信号", 2),
          buildComIColumnItem("运行信号", 3),
          buildComIColumnItem("故障反馈", 4),
        ],
      ),
    );
  }

  Widget buildWaterPumpRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildComQColumnItem("启动控制", 0),
          buildComIColumnItem("远程信号", 1),
          buildComIColumnItem("运行信号", 2),
          buildComIColumnItem("故障反馈", 3),
        ],
      ),
    );
  }

  Widget buildCrossHoleRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildComQColumnItem("打开控制", 0),
          buildComQColumnItem("关闭控制", 1),
          buildComIColumnItem("远程信号", 2),
          buildComIColumnItem("运行信号", 3),
          buildComIColumnItem("故障反馈", 4),
        ],
      ),
    );
  }

  Widget buildWindSpeedRow() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildPortItem(0),
              buildFunctionCodeItem(1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Form(
                key: _idForm,
                child: Container(
                  width: 150,
                  child: TextFormField(
                    controller: _id,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      labelText: "从机ID",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "从机ID";
                      if (int.tryParse(value) == null) return "非法数字";
                      return null;
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        submitCom(2, int.parse(value));
                      }
                    },
                  ),
                ),
              ),
              Form(
                key: _masterAddrForm,
                child: Container(
                  width: 150,
                  child: TextFormField(
                    controller: _masterAddr,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      labelText: "主站地址",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "从机ID";
                      if (int.tryParse(value) == null) return "非法数字";
                      return null;
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        submitCom(3, int.parse(value));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Form(
                key: _countForm,
                child: Container(
                  width: 150,
                  child: TextFormField(
                    controller: _count,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: "数量",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "从机ID";
                      if (int.tryParse(value) == null) return "非法数字";
                      return null;
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        submitCom(4, int.parse(value));
                      }
                    },
                  ),
                ),
              ),
              Form(
                key: _slaveAddrForm,
                child: Container(
                  width: 150,
                  child: TextFormField(
                    controller: _slaveAddr,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: "从机地址",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "从机ID";
                      if (int.tryParse(value) == null) return "非法数字";
                      return null;
                    },
                    onChanged: (String? value) {
                      if (value != null) {
                        submitCom(5, int.parse(value));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(height: 20)
        ],
      ),
    );
  }

  Widget buildCOVIRow() {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }

  Widget buildLightInsideRow() {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }

  Widget buildLightOutsideRow() {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }

  Widget buildWidget() {
    int scene = widget.logicRule.scene;
    if (scene == 1) {
      // 1: "单点控车指（4显）",
      return buildLaneIndicatorRow();
    } else if ([2, 4, 6, 8].contains(scene)) {
      // 2: "组合式车指（单面互锁；4显，反馈为独立点）",
      // 4: "组合式车指（单面互锁；4显，反馈为组合点）",
      // 6: "组合式车指（双面互锁；4显，反馈为独立点）",
      // 8: "组合式车指（双面互锁；4显，反馈为组合点）",
      return buildLaneIndicatorRow2();
    } else if ([3, 5, 7, 9].contains(scene)) {
      // 3: "组合式车指（单面互锁；6显，反馈为独立点）",
      // 5: "组合式车指（单面互锁；6显，反馈为组合点）",
      // 7: "组合式车指（双面互锁；6显，反馈为独立点）",
      // 9: "组合式车指（双面互锁；6显，反馈为组合点）",

      return buildLaneIndicatorRow3();
    } else if (10 == scene) {
      // 10: "交通信号灯（4显）",
      return buildTrafficRow();
    } else if ([11, 12].contains(scene)) {
      // 11: "风机（3控制点，延时保护；互锁）",
      // // 12: "风机（2控制点，延时保护；互锁）",
      // if (11 == scene) {
      return buildFanRow();
      // }
      // return buildFanRow2();
    } else if (13 == scene) {
      // 13: "卷帘门（3控制点，点动信号）",
      return buildDoorRow();
    } else if ([14, 15].contains(scene)) {
      // // 14: "照明（单控制点）",
      // 15: "照明（双控制点）",
      // if (14 == scene) {
      //   return buildLightRow();
      // }
      return buildLightRow2();
    } else if (16 == scene) {
      // 16: "水泵（单控制点）",
      return buildWaterPumpRow();
    } else if (17 == scene) {
      // 17: "风速风向",
      return buildWindSpeedRow();
    } else if (18 == scene) {
      // 18: "COVI检测",
      return buildCOVIRow();
    } else if (19 == scene) {
      // 19: "洞内光强",
      return buildLightInsideRow();
    } else if (20 == scene) {
      // 20: "洞外光照",
      return buildLightOutsideRow();
    } else if (21 == scene) {
      return buildCrossHoleRow();
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
                  onChanged: changeScene,
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

                debugPrint("------------------");

                if (saved.isEmpty) {
                  return showSnackBar("未设置逻辑", key);
                }
                saved.sort((a, b) => a.index.compareTo(b.index));
                String data = saved.map((e) => e.toList().join(',')).join(',');
                await prefs.setString(mac, data);
                debugPrint("------------------ $mac");
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

            final logic = rules[index];
            //           17: "风速风向",
            // 18: "COVI检测",
            // 19: "洞内光强",
            // 20: "洞外光照",

            List<int> values =
                logic.values.map((e) => e == 255 ? -1 : e).toList();
            if ([17, 18, 19, 20].contains(logic.scene)) {
              values =
                  logic.values.map((e) => (e == -1 || e == 0) ? 1 : e).toList();
            }
            logic.values = values;

            return LogicRuleItem(
              key: key,
              logicRule: logic,
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
