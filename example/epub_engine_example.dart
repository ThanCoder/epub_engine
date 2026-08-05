// ignore_for_file: unused_import

import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/utils/epub_thumbnail_worker.dart';
import 'package:xml/xml.dart';

void main() async {
  final path =
      '/home/thancoder/Documents/Docs/epub/ဆရာကြီးဦးရွှေအောင်၊_အမြင်များပြောင်းလဲခြင်းနှင့်အတွေးအမြင်စာစုများ.epub';
  final ep = EpubEngine();
  ep.open(path);
  final items = ep.getChapters();
  for (var ch in items) {
    print(ch);
  }
  print(ep.getChapterContent(items.first));

  // final name = files.first.path.split('/').last;
  // await EpubThumbnailWorker.getInstance.generate(
  //   files.first.path,
  //   '${outDir.path}/$name',
  // );
}
