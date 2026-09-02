import 'package:epub_engine/src/core/models/epub_ncx.dart';
import 'package:epub_engine/src/core/result_t.dart';
import 'package:xml/xml.dart';

class EpubNcxParser {
  static const ncx = 'http://www.daisy.org/z3986/2005/ncx/';

  static Result<EpubNcx, String> parse(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      final root = document.rootElement;

      final head = root.findElements('head', namespaceUri: ncx).firstOrNull;

      final uuid = head
          ?.findElements('meta', namespaceUri: ncx)
          .where((e) => e.getAttribute('name') == 'dtb:uuid')
          .map((e) => e.getAttribute('content'))
          .firstOrNull;

      final title = root
          .findElements('docTitle', namespaceUri: ncx)
          .firstOrNull
          ?.findElements('text', namespaceUri: ncx)
          .firstOrNull
          ?.innerText
          .trim();

      final author = root
          .findElements('docAuthor', namespaceUri: ncx)
          .firstOrNull
          ?.findElements('text', namespaceUri: ncx)
          .firstOrNull
          ?.innerText
          .trim();

      final navMap = root.findElements('navMap', namespaceUri: ncx).firstOrNull;

      final navPoints = navMap == null
          ? <EpubNavPoint>[]
          : navMap
                .findElements('navPoint', namespaceUri: ncx)
                .map(_parseNavPoint)
                .toList();

      return Ok(
        EpubNcx(uuid: uuid, title: title, author: author, navPoints: navPoints),
      );
    } catch (e) {
      return Err(e.toString());
    }
  }

  static EpubNavPoint _parseNavPoint(XmlElement element) {
    final label =
        element
            .findElements('navLabel', namespaceUri: ncx)
            .firstOrNull
            ?.findElements('text', namespaceUri: ncx)
            .firstOrNull
            ?.innerText
            .trim() ??
        '';

    final content = element
        .findElements('content', namespaceUri: ncx)
        .firstOrNull;

    final children = element
        .findElements('navPoint', namespaceUri: ncx)
        .map(_parseNavPoint)
        .toList();

    return EpubNavPoint(
      id: element.getAttribute('id') ?? '',
      playOrder: int.tryParse(element.getAttribute('playOrder') ?? ''),
      className: element.getAttribute('class'),
      label: label,
      src: content?.getAttribute('src') ?? '',
      children: children,
    );
  }
}
