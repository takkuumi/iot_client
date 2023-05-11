import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Recoder extends StatefulWidget {
  const Recoder({Key? key}) : super(key: key);

  @override
  State<Recoder> createState() => _RecoderState();
}

class _RecoderState extends State<Recoder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("操作记录"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        tooltip: "导出",
        onPressed: () {},
      ),
    );
  }
}
