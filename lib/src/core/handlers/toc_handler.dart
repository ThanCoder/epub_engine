import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/models/epub_toc_item.dart';
import 'package:xml/xml.dart';

mixin TocHandler on IEpubCoreEngine {
  /// Toc Content
  String? getTocContent(EpubTocItem item) {
    String path = item.src;
    if (ctx.opfParentPath.isNotEmpty) {
      path = '${ctx.opfParentPath}/${item.src}';
    }
    return zipIoHandler.getFileContent(path);
  }

  /// load toc
  List<EpubTocItem> loadToc(String opfContent) {
    if (opfContent.isEmpty) return const [];

    final xml = XmlDocument.parse(opfContent);

    const ncxNs = 'http://www.daisy.org/z3986/2005/ncx/';

    final navMap = xml
        .findAllElements('navMap', namespaceUri: ncxNs)
        .firstOrNull;

    if (navMap == null) {
      return const [];
    }

    return _parseNavPoints(
      navMap.findElements('navPoint', namespaceUri: ncxNs),
      ncxNs,
    );
  }

  List<EpubTocItem> _parseNavPoints(
    Iterable<XmlElement> elements,
    String namespaceUri,
  ) {
    return elements.map((element) {
      final navLabel = element
          .findElements('navLabel', namespaceUri: namespaceUri)
          .firstOrNull;

      final text = navLabel
          ?.findElements('text', namespaceUri: namespaceUri)
          .firstOrNull
          ?.innerText
          .trim();

      final content = element
          .findElements('content', namespaceUri: namespaceUri)
          .firstOrNull;

      final children = _parseNavPoints(
        element.findElements('navPoint', namespaceUri: namespaceUri),
        namespaceUri,
      );

      return EpubTocItem(
        id: element.getAttribute('id') ?? '',
        playOrder: int.tryParse(element.getAttribute('playOrder') ?? ''),
        title: text ?? '',
        src: content?.getAttribute('src') ?? '',
        children: children,
      );
    }).toList();
  }
}
