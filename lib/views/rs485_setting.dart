import 'package:flutter/material.dart';

Map<int, String> _kDataBitOptions = Map.from({0: '8位', 1: '9位'});

Map<int, String> _kParityOptions = Map.from({0: '无奇偶校验', 1: '奇校验', 2: '偶校验'});

Map<int, String> _kStopBitOptions = Map.from({0: '1位', 1: '2位'});

Map<int, String> _kBaudRateOptions = Map.from({
  0: '300bit/s',
  1: '600bit/s',
  2: '1200bit/s',
  3: '2400bit/s',
  4: '4800bit/s',
  5: '9600bit/s',
  6: '19200bit/s',
  7: '115200bit/s',
});

Map<int, String> _kProtocolOptions = Map.from({0: '自定义协议', 1: 'Modbus RTU'});

Map<int, String> _kPortTypeOptions = Map.from({0: '主站（客服端）', 1: '从站（服务端）'});

List<DropdownMenuItem<int>> genDropdownItems(Map<int, String> options) {
  return options.keys
      .map((e) => DropdownMenuItem<int>(
            alignment: Alignment.center,
            value: e,
            child: Text(options[e]!, style: TextStyle(fontSize: 10)),
          ))
      .toList();
}

class RS485Setting extends StatefulWidget {
  const RS485Setting({Key? key}) : super(key: key);

  @override
  State<RS485Setting> createState() => _RS485SettingState();
}

class _RS485SettingState extends State<RS485Setting> {
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'logic_control_setting');

  Widget _customLayout(String label, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          child: Text(label, style: TextStyle(fontSize: 12)),
        ),
        child
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RS-485设置'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () => {
                // 保存逻辑配置
              },
              child: Text("保存"),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("RS485 1"),
                    color: Colors.blueAccent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "数据长度",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("数据长度"),
                              value: 0,
                              items: genDropdownItems(_kDataBitOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "校验方式",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("校验方式"),
                              value: 0,
                              items: genDropdownItems(_kParityOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "停止位",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("停止位"),
                              value: 0,
                              items: genDropdownItems(_kStopBitOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "波特率",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("波特率"),
                              value: 0,
                              items: genDropdownItems(_kBaudRateOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "主从站",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("端口主从"),
                              value: 0,
                              items: genDropdownItems(_kPortTypeOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "协议类型",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("协议类型"),
                              value: 0,
                              items: genDropdownItems(_kProtocolOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("RS485 2"),
                    color: Colors.blueAccent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "数据长度",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("数据长度"),
                              value: 0,
                              items: genDropdownItems(_kDataBitOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "校验方式",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("校验方式"),
                              value: 0,
                              items: genDropdownItems(_kParityOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "停止位",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("停止位"),
                              value: 0,
                              items: genDropdownItems(_kStopBitOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "波特率",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("波特率"),
                              value: 0,
                              items: genDropdownItems(_kBaudRateOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "主从站",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("端口主从"),
                              value: 0,
                              items: genDropdownItems(_kPortTypeOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "协议类型",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("协议类型"),
                              value: 0,
                              items: genDropdownItems(_kProtocolOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("RS485 3"),
                    color: Colors.blueAccent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "数据长度",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("数据长度"),
                              value: 0,
                              items: genDropdownItems(_kDataBitOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "校验方式",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("校验方式"),
                              value: 0,
                              items: genDropdownItems(_kParityOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "停止位",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("停止位"),
                              value: 0,
                              items: genDropdownItems(_kStopBitOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "波特率",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("波特率"),
                              value: 0,
                              items: genDropdownItems(_kBaudRateOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _customLayout(
                            "主从站",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("端口主从"),
                              value: 0,
                              items: genDropdownItems(_kPortTypeOptions),
                              onChanged: (value) {},
                            ),
                          ),
                          _customLayout(
                            "协议类型",
                            DropdownButton<int>(
                              alignment: Alignment.center,
                              hint: Text("协议类型"),
                              value: 0,
                              items: genDropdownItems(_kProtocolOptions),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
