import 'dart:io';
import 'dart:typed_data';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/epub_core.dart';
import 'package:epub_engine/src/special_html/cache_html.dart';
import 'package:html/parser.dart';

class EpubSpineItem {
  const EpubSpineItem({required this.idref, required this._epubCore});
  final IEpubCore _epubCore;
  final String idref;

  @override
  String toString() => 'EpubSpineItem(idref: $idref)';
}

extension EpubSpineItemExt on EpubSpineItem {
  int get manifestItemsIndex =>
      _epubCore.ctx.manifestItems.indexWhere((e) => e.id == idref);

  EpubManifestItem? get toManifestItem {
    final index = manifestItemsIndex;
    if (index == -1) return null;
    return _epubCore.ctx.manifestItems[index];
  }

  Uint8List? get content {
    final index = manifestItemsIndex;
    if (index == -1) return null;
    final item = _epubCore.ctx.manifestItems[index];
    return item.content;
  }

  String? get contentText {
    final index = manifestItemsIndex;
    if (index == -1) return null;
    final item = _epubCore.ctx.manifestItems[index];
    return item.contentText;
  }

  List<String> cacheHtmlList(String cachePath) {
    final htmlStr = cacheHtml(cachePath);
    final document = parse(htmlStr);

    final body = document.querySelector('body');

    if (body == null) return [];

    return body.children.map((e) => e.outerHtml).toList();
  }

  String cacheHtml(String cachePath) {
    return CacheHtml.getCacheHtml(
      contentText ?? '',
      getStyleContent: (href) {
        final fullPath = _epubCore.getFullPathByHref(href);
        final content = _epubCore.reader.getContentText(fullPath) ?? '';

        final result = content.replaceAllMapped(
          RegExp(r'''url\(\s*["\']?([^)"\']+)["\']?\s*\)'''),
          (match) {
            final path = _epubCore.getFullPathByHref(match.group(1)!);
            // print('font path: $path');
            final cFile = File('$cachePath${Platform.pathSeparator}$path');
            if (!cFile.existsSync()) {
              if (!cFile.parent.existsSync()) {
                cFile.parent.createSync(recursive: true);
              }
              final con = _epubCore.reader.getContent(path);
              if (con != null) {
                cFile.writeAsBytesSync(con, flush: true);
              }
            }

            return 'url("${cFile.path}")';
          },
        );
        return result;
      },
      replacePath: (path) {
        final fullPath = _epubCore.getFullPathByHref(path);
        final cFile = File('$cachePath${Platform.pathSeparator}$fullPath');
        if (!cFile.existsSync()) {
          if (!cFile.parent.existsSync()) {
            cFile.parent.createSync(recursive: true);
          }
          final con = _epubCore.reader.getContent(fullPath);
          if (con != null) {
            cFile.writeAsBytesSync(con, flush: true);
          }
        }
        return cFile.path;
      },
    );
  }
}
