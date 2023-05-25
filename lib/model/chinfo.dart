// Command AT+CHINFO
// Response +CHINFO=Param1,Param2,Param3,Param4
// Param1 连接索引
// Param2 连接状态 (1：未连接，2：连接中，3：已连接)
// Param3 连接角色 (0：从机，1：主机)
// Param4 对端地址

class Chinfo {
  int no;
  int state;
  int rule;
  String mac;

  Chinfo(
      {required this.no,
      required this.state,
      required this.rule,
      required this.mac});
}

// +CHINFO=9,1,0,000000000000
List<Chinfo> parseChinfos(String text) {
  List<Chinfo> chinfos = [];
  text
      .split(RegExp(r"\r\n"))
      .where((s) => s.startsWith("+CHINFO=") && s.length == 26)
      .map((e) => e.replaceAll(RegExp(r'\+CHINFO='), ''))
      .forEach((element) {
    List<String> items = element.split(',').map((e) => e.trim()).toList();
    String mac = items[3];

    if (items.length == 4) {
      int no = int.parse(items[0]);
      int state = int.parse(items[1]);
      int rule = int.parse(items[2]);

      chinfos.add(Chinfo(no: no, state: state, rule: rule, mac: mac));
    }
  });

  return chinfos;
}
