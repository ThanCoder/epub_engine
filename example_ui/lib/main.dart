import 'dart:io';

import 'package:example_ui/epub_reader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp(), theme: .dark()));
}

class MyApp extends StatefulWidget {
  const new({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  List<String> list = [];
  void init() {
    final dir = Directory('/home/thancoder/Documents/EPUB');
    for (var f in dir.listSync()) {
      if (!f.path.endsWith('.epub')) continue;
      list.add(f.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => listItem(list[index]),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
    );
  }

  Widget listItem(String path) {
    return ListTile(
      leading: SizedBox(width: 100, height: 100, child: Icon(Icons.image)),
      title: Text(path.split('/').last),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EpubReader(path: path)),
        );
      },
    );
  }
}
