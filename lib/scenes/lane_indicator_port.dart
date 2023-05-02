import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iot_client/ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../futs/hal.dart';

class LaneIndicatorPort extends StatefulWidget {
  const LaneIndicatorPort({Key? key}) : super(key: key);

  @override
  State<LaneIndicatorPort> createState() => _LaneIndicatorPortState();
}

enum LaneIndicatorPortState { green, red }

class _LaneIndicatorPortState extends State<LaneIndicatorPort>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'lane_indicator');

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
          title: const Text('车道指示器逻辑控制配置'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: Container(
            child: Form(
              child: Column(
                children: [
                  DropdownButton(
                    hint: Text("请选择车道指示器组合类型"),
                    items: [
                      DropdownMenuItem(
                        child: Text("单点控车指"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(单面互锁；4显，反馈为独立点)"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(单面互锁；6显，反馈为独立点)"),
                        value: 3,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(单面互锁；4显，反馈为组合点)"),
                        value: 4,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(单面互锁；6显，反馈为组合点)"),
                        value: 5,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(双面互锁；4显，反馈为独立点)"),
                        value: 6,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(双面互锁；6显，反馈为独立点)"),
                        value: 7,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(双面互锁；4显，反馈为组合点)"),
                        value: 8,
                      ),
                      DropdownMenuItem(
                        child: Text("组合式车指(双面互锁；6显，反馈为组合点)"),
                        value: 9,
                      ),
                    ],
                    onChanged: (value) {
                      debugPrint("$value");
                    },
                  ),
                  SizedBox.fromSize(size: Size.fromHeight(20)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("X位操作区"),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X0"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X1"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X2"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X3"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X4"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X5"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X6"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X7"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X8"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X9"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X10"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X11"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X12"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X13"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X14"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("X15"),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox.fromSize(size: Size.fromHeight(20)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Y位操作区"),
                        SizedBox.fromSize(size: Size.fromHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y0"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y1"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y2"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y3"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y4"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y5"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y6"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y7"),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Checkbox(value: false, onChanged: (value) {}),
                                  Text("Y8"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
