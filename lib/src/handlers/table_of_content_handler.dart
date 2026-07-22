import 'package:epub_engine/src/i_epub_engine.dart';
import 'package:epub_engine/src/models/epub_nav.dart';
import 'package:xml/xml.dart';

mixin TableOfContentHandler on IEpubEngine {
  /// Get Content
  String getNavItemContent(EpubNavItem item) {
    return core.zipIoHandler.getFileContent(item.path)!;
  }

  /// ### Navigation Tree
  ///
  /// Supported -> `v2`
  ///
  /// Table Of Content
  ///
  EpubNav? getTableOfContent() {
    final xmlContent = getTableOfContentString();
    if (xmlContent == null) return null;
    final title = core.xmlParser.queryTagValue(xmlContent, 'docTitle');
    final items = <EpubNavItem>[];

    for (var ele in core.xmlParser.findAllElements(xmlContent, 'navPoint')) {
      final id = ele.getAttribute('id')?.trim();
      final label = ele
          .getElement('navLabel')
          ?.getElement('text')
          ?.innerText
          .trim();
      final src = ele.getElement('content')?.getAttribute('src')?.trim();
      // print('id: $id');
      // print('lable: $label');
      // print('src: $src');
      if (label == null) continue;
      items.add(EpubNavItem(point: id!, label: label, path: 'OEBPS/$src'));
    }
    return EpubNav(title: title ?? 'Null', items: items);
  }
}
