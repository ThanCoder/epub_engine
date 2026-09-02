import 'package:flutter/material.dart';

class SourcePage extends StatelessWidget {
  const new({super.key, required this.htmls});

  final List<String> htmls;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: htmls.length,
      itemBuilder: (context, index) => SelectableText(htmls[index]),
    );
  }
}
