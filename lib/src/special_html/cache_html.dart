import 'package:html/dom.dart';
import 'package:html/parser.dart';

class CacheHtml {
  static String getCacheHtml(
    String htmlStr, {
    required String Function(String path) replacePath,
    required String Function(String href) getStyleContent,
  }) {
    final html = parse(htmlStr);
    // link
    for (final link in html.querySelectorAll('link[rel="stylesheet"]')) {
      final href = link.attributes['href'];
      if (href == null) continue;
      final content = getStyleContent(href);
      final style = Element.tag('style');
      style.text = content;
      link.replaceWith(style);
    }

    // img
    html.querySelectorAll('img').forEach((ele) {
      for (var entry in ele.attributes.entries) {
        final key = entry.key.toString();
        if (key == 'src') {
          ele.attributes[entry.key] = replacePath(entry.value);
        }
      }
    });

    //svg
    html.querySelectorAll('svg').forEach((svg) {
      final image = svg.querySelector('image');
      String src = '';
      for (var entry in image!.attributes.entries) {
        final key = entry.key.toString();
        if (key == 'xlink:href') {
          src = entry.value;
        }
      }
      final img = Element.tag('img');
      img.attributes['src'] = replacePath(src);
      svg.replaceWith(img);
    });

    return html.outerHtml;
  }
}
