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
