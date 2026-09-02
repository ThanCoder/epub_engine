part of '../epub_core.dart';

mixin CoverLogic on IEpubCore {
  String get coverPath {
    if (ctx.metadata.coverId.isEmpty) return '';

    final coverItemIndex = ctx.manifestItems.indexWhere(
      (e) => e.id == ctx.metadata.coverId,
    );
    if (coverItemIndex == -1) {
      return '';
    }

    final item = ctx.manifestItems[coverItemIndex];
    if (ctx.rootPath.isNotEmpty) {
      return '${ctx.rootPath}/${item.href}';
    }
    return item.href;
  }

  Uint8List? get coverBytes {
    final path = coverPath;
    if (path.isEmpty) return null;
    return reader.getContent(path);
  }
}
