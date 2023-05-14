import 'package:iot_client/ffi.dart';

Future<void> disconectAll() async {
  await api.bleLedisc(index: 0);
  await api.bleLedisc(index: 1);
  await api.bleLedisc(index: 2);
  await api.bleLedisc(index: 3);
  await api.bleLedisc(index: 4);
  await api.bleLedisc(index: 5);
  await api.bleLedisc(index: 6);
  await api.bleLedisc(index: 7);
  await api.bleLedisc(index: 8);
  await api.bleLedisc(index: 9);
}

// Future<bool> checkConnection(String mac) async {
//   SerialResponse resp = await api.bleChinfo();
//   Uint8List? data = resp.data;
//   if (data == null) {
//     return false;
//   }
//   String chinfos = String.fromCharCodes(data);
//   debugPrint(">>>>>>>>>>>>>>>>>$chinfos<<<<<<<<<<<<<<<<<<<<<");
//   if (chinfos.contains(mac)) {
//     bool res = chinfos
//         .split(RegExp(r"\r\n"))
//         .where((s) => s.startsWith("+CHINFO=") && s.contains(mac))
//         .any((element) {
//       RegExp m = RegExp("\\+CHINFO=\\d,3,(1|0),$mac");
//       return m.hasMatch(element);
//     });

//     return res;
//   }
//   return false;
// }

// bool checkConnectionSync(String responseText, String mac) {
//   if (responseText.contains(mac)) {
//     bool res = responseText
//         .split(RegExp(r"\r\n"))
//         .where((s) => s.startsWith("+CHINFO=") && s.contains(mac))
//         .any((element) {
//       RegExp m = RegExp("\\+CHINFO=\\d,3,(1|0),$mac");
//       return m.hasMatch(element);
//     });

//     return res;
//   }
//   return false;
// }
