// ignore_for_file: unused_import

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:epub_engine/epub_engine.dart';
import 'package:xml/xml.dart';

void main() async {
  final path = '/home/thancoder/Documents/epub/ဝါးမြိုခြင်းစာအုပ်_စ_ဆုံး.epub';
  // final archive = ZipDecoder().decodeStream(InputFileStream(path));
  // for (var file in archive) {
  //   if (!file.isFile) continue;
  //   print('name: ${file.name} - isFile: ${file.isFile}');
  // }

  final epub = EpubEngine();
  epub.open(path);
  final list = epub.getChapters();
  print('content: ${epub.getChapterContent(list.first)!.length}');

  // print(epub.getBook());
  // print('data: ${epub.getCoverData()}');
  // print('save cover: ${epub.saveAsCoverPath('test.png')}');

  epub.dispose();
}
