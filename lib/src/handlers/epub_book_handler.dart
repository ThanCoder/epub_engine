import 'package:epub_engine/src/i_epub_engine.dart';
import 'package:epub_engine/src/models/epub_book.dart';

mixin EpubBookHandler on IEpubEngine {
  EpubBook? getBook() {
    final content = core.zipIoHandler.getFileContent('OEBPS/content.opf');
    if (content == null) return null;
    final language = core.xmlParser.queryTagValue(content, 'dc:language');
    final title = core.xmlParser.queryTagValue(content, 'dc:title');
    final creator = core.xmlParser.queryTagValue(content, 'dc:creator');
    final date = core.xmlParser.queryTagValue(content, 'dc:date');
    final identifier = core.xmlParser.queryTagValue(content, 'dc:identifier');

    return EpubBook(
      language: language ?? '',
      title: title ?? '',
      creator: creator ?? '',
      date: date ?? '',
      identifier: identifier ?? '',
      parentPath: 'OEBPS',
    );
  }
}
