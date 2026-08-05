import 'package:epub_engine/src/i_epub_engine.dart';
import 'package:epub_engine/src/models/book_chapter_item.dart';
import 'package:xml/xml.dart';

mixin EpubChapterHandler on IEpubEngine {
  List<BookChapterItem> getChapters() {
    final content = getContentOpfString();
    if (content == null) return [];

    List<BookChapterItem> list = [];
    final document = XmlDocument.parse(content);
    final manifest = document.findAllElements('manifest').firstOrNull;

    Map<String, XmlElement> metaItems = {};

    if (manifest != null) {
      final items = manifest.findElements('item');

      for (final item in items) {
        final id = item.getAttribute('id');
        // final href = item.getAttribute('href');
        // print('id: $id - href: $href');
        if (id == null) continue;

        metaItems[id] = item;
      }
    }
    // search spain
    final spine = document.findAllElements('spine').firstOrNull;

    if (spine != null) {
      final itemrefs = spine.findElements('itemref');

      for (final itemref in itemrefs) {
        final idref = itemref.getAttribute('idref');
        final item = metaItems[idref];
        if (item == null) continue;
        final id = item.getAttribute('id');
        final href = item.getAttribute('href');
        list.add(.new(id: id!, href: href!));
      }
    }
    return list;
  }

  String? getChapterContent(BookChapterItem chapter) {
    final content = core.zipIoHandler.getFileContent(chapter.href);
    if (content != null) return content;

    return null;
  }
}
