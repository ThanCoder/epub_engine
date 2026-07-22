// ignore_for_file: unused_import

import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/utils/epub_thumbnail_worker.dart';
import 'package:xml/xml.dart';

void main() async {
  final dir = Directory('/home/thancoder/Downloads/Telegram Desktop');
  final outDir = Directory(
    '/home/thancoder/projects/dart_packages/epub_engine/out',
  );
  if (!outDir.existsSync()) {
    outDir.createSync();
  }
  final files = dir.listSync(followLinks: false);
  final ep = EpubEngine();
  ep.open(files.first.path);
  print('path: ${files.first.path}');
  print(ep.getBook());
  print(ep.getFonts());
  print(ep.getTableOfContent());
  print(ep.getChapters());

  // final name = files.first.path.split('/').last;
  // await EpubThumbnailWorker.getInstance.generate(
  //   files.first.path,
  //   '${outDir.path}/$name',
  // );
}
