// ignore_for_file: unused_local_variable, unused_import

import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/workers/epub_cover_worker.dart';
import 'package:xml/xml.dart';

void main() async {
  final path =
      '/home/thancoder/Documents/Docs/epub/မူကွဲလမ်းဆုံကဗျာများ၊_ကဗျာဆရာစုံ.epub';

  final ep = EpubEngine();
  final res = await ep.open(path);
  print('opened: $res');
  final info = ep.info;
  print(info);

  for (var toc in ep.toc) {
    print(toc);
  }

  // print('cover: ${await ep.coverBytes}');

  // ep.saveAsCoverSync('${info.title}.png');

  // print('bytes: ${ep.getCoverBytes}');

  // for (var ch in ep.getChapters) {
  //   print(ch);
  // }

  // final ch = ep.chapters.first;
  // print('content: ${await ep.getChapterContent(ch)}');
  // for (var toc in ep.ctx.toc) {
  //   print(toc);
  // }

  // final toc = ep.ctx.toc.first;
  // print('toc content: ${await ep.getTocContent(toc)}');
}
