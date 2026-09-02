import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class HtmlPage extends StatelessWidget {
  const new({super.key, required this.htmls});

  final List<String> htmls;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: htmls.length,
      itemBuilder: (context, index) => HtmlWidget(
        htmls[index],
        customWidgetBuilder: (ele) {
          if (ele.localName == 'img') {
            final f = File(ele.attributes['src'] ?? '');
            if (f.existsSync()) {
              return Image.file(f);
            }
          }
          return null;
        },
      ),
    );
  }
}
