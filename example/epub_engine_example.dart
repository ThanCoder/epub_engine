// ignore_for_file: unused_local_variable, unused_import

import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/utils/epub_thumbnail_worker.dart';
import 'package:xml/xml.dart';

void main() async {
  final path =
      '/home/thancoder/Documents/Docs/epub/ဆရာကြီးဦးရွှေအောင်၊_အမြင်များပြောင်းလဲခြင်းနှင့်အတွေးအမြင်စာစုများ.epub';
  // final path =
  //     '/home/thancoder/Documents/Docs/epub/ဝါးမြိုခြင်းစာအုပ်_စ_ဆုံး.epub';
  final ep = EpubEngine();
  ep.open(path);

  final info = ep.info;
  print(info);

  ep.saveAsCoverSync('${info.title}.png');

  // print('bytes: ${ep.core.getCoverBytes(info!)}');

  // for (var ch in ep.core.getChapters()) {
  //   print(ch);
  // }

  // final ch = ep.core.getChapters().first;
  // print('content: ${ep.core.getChapterContent(ch)}');
  // for (var toc in ep.core.ctx.toc) {
  //   print(toc);
  // }

  // final toc = ep.ctx.toc.first;
  // print('toc content: ${ep.getTocContent(toc)}');
}
