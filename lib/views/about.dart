import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:iot_client/views/components/pubspec.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final aboutPage = AboutPage(
    values: {
      'version': Pubspec.version,
      'buildNumber': Pubspec.versionBuild.toString(),
      'year': DateTime.now().year.toString(),
      'author': Pubspec.authorsName.join(', '),
    },
    title: const Text('关于我们'),
    applicationVersion: '版本 {{ version }}, 构建版本号 #{{ buildNumber }}',
    applicationDescription: const Text(
      Pubspec.description,
      textAlign: TextAlign.justify,
    ),
    // applicationIcon: const FlutterLogo(size: 100),
    applicationLegalese: 'Copyright © {{ author }}, {{ year }}',
    children: const <Widget>[
      MarkdownPageListTile(
        filename: 'README.md',
        title: Text('说明'),
        icon: Icon(Icons.all_inclusive),
      ),
      MarkdownPageListTile(
        filename: 'CHANGELOG.md',
        title: Text('更新日志'),
        icon: Icon(Icons.view_list),
      ),
      MarkdownPageListTile(
        filename: 'LICENSE.md',
        title: Text('许可信息'),
        icon: Icon(Icons.description),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: aboutPage,
    );
  }
}
