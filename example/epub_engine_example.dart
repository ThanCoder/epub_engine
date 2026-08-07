// ignore_for_file: unused_local_variable, unused_import

import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/workers/epub_cover_worker.dart';
import 'package:html/parser.dart';
import 'package:xml/xml.dart';

void main() async {
  final path =
      '/home/thancoder/Documents/ဝိနည်းပိဋက - ပါရာဇိကဏ် ပါဠိတော် မြန်မာပြန်.epub';

  final ep = EpubEngine();
  final res = await ep.open(path);
  print('opened: $res');

  final ch = ep.chapters.first;
  final html = await ep.getChapterContent(ch);
  if (html == null) return;

  print('cover: ${await ep.coverBytes}');
  // ep.saveAsCoverSync(outpath)

  // final resolverList = <CachePathResolver>[];
  // final cachePath = '/home/thancoder/projects/dart_plugins/epub_engine/cache';

  // final resHtml = ep.resolveHtmlContent(
  //   html,
  //   onResolve: (tag, attribute, content) {
  //     print('tag: $tag - attribute: $attribute - content: $content');
  //     final zipInnerPath = ep.getZipFullpath(content);
  //     final cacheFullpath = '$cachePath/$zipInnerPath';

  //     print('zipInnerPath: $zipInnerPath');
  //     print('cacheFullpath: $cacheFullpath');

  //     final resolver = CachePathResolver(
  //       zipInnerPath: zipInnerPath,
  //       cacheFullpathPath: cacheFullpath,
  //     );
  //     resolverList.add(resolver);
  //     return resolver.cacheFullpathPath;
  //   },
  // );
  // await ep.resolveCaches(resolverList);

  // // print(resHtml);
  // await File('test.html').writeAsString(resHtml);
}
