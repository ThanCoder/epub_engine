import 'package:example_ui/html_page.dart';
import 'package:example_ui/source_page.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  const new({super.key, required this.htmls});
  final List<String> htmls;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IndexedStack(
          index: index,
          children: [
            HtmlPage(htmls: widget.htmls),
            SourcePage(htmls: widget.htmls),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          .new(icon: Icon(Icons.home), label: 'Home'),
          .new(icon: Icon(Icons.source), label: 'Source'),
        ],
      ),
    );
  }
}
