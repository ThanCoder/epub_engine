import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class ContentPage extends StatefulWidget {
  const new({super.key, required this.content});
  final String content;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IndexedStack(
            index: index,
            children: [
              HtmlWidget(widget.content),
              SelectableText(widget.content),
            ],
          ),
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
