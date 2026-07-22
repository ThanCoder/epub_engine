import 'package:epub_engine/src/i_epub_engine.dart';
import 'package:epub_engine/src/models/book_chapter_item.dart';

mixin EpubChapterHandler on IEpubEngine {
  List<BookChapterItem> getChapters() {
    final content = getContentOpfString();
    if (content == null) return [];

    List<BookChapterItem> list = [];
    for (var item in core.xmlParser.findAllElements(content, 'itemref')) {
      final val = item.getAttribute('idref');
      if (val == null) continue;
      list.add(BookChapterItem(path: 'OEBPS/Text/$val', name: val));
    }
    return list;
  }

  String? getChapterContent(BookChapterItem chapter) {
    final content = core.zipIoHandler.getFileContent(chapter.path);
    if (content != null) return content;

    return null;
  }
}
