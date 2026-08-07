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
      '/home/thancoder/Documents/Docs/epub/မူကွဲလမ်းဆုံကဗျာများ၊_ကဗျာဆရာစုံ.epub';

  final ep = EpubEngine();
  final res = ep.openSync(path);
  print('opened: $res');

  final ch = ep.chapters.first;
  final html = ep.getChapterContentSync(ch);
  if (html == null) return;

  final resolverList = <CachePathResolver>[];

  final resHtml = ep.resolveHtmlContent(
    html,
    onResolve: (tag, attribute, content) {
      print('tag: $tag - attribute: $attribute - content: $content');
      final zipInnerPath = ep.getZipFullpath(content);
      final cacheFullpath = 'cache/$zipInnerPath';
      
      final resolver = CachePathResolver(
        zipInnerPath: zipInnerPath,
        cacheFullpathPath: cacheFullpath,
      );
      resolverList.add(resolver);
      return resolver.cacheFullpathPath;
    },
  );
  await ep.resolveCaches(resolverList);

  print(resHtml);
}
