// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epub_engine/src/core/core_engine.dart';
import 'package:epub_engine/src/handlers/epub_book_handler.dart';
import 'package:epub_engine/src/handlers/epub_chapter_handler.dart';
import 'package:epub_engine/src/handlers/epub_content_handler.dart';
import 'package:epub_engine/src/handlers/epub_cover_handler.dart';
import 'package:epub_engine/src/handlers/font_handler.dart';
import 'package:epub_engine/src/handlers/style_handler.dart';
import 'package:epub_engine/src/handlers/table_of_content_handler.dart';
import 'package:epub_engine/src/i_epub_engine.dart';

class EpubEngine extends IEpubEngine
    with
        EpubContentHandler,
        EpubBookHandler,
        EpubCoverHandler,
        EpubChapterHandler,
        FontHandler,
        StyleHandler,
        TableOfContentHandler {
  @override
  CoreEngine core = CoreEngine();

  @override
  void open(String path) {
    core.open(path);
  }

  @override
  void dispose() {
    core.dispose();
  }
}
