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
    return getFullPathByHref(item.href);
  }

  Uint8List? get coverBytes {
    final path = coverPath;
    if (path.isEmpty) return null;
    return reader.getContent(path);
  }

  Result<bool, String> coverSaveToSync(String outpath) {
    try {
      final bytes = coverBytes;
      if (bytes == null) {
        return Ok(false);
      }
      final f = File(outpath);
      f.writeAsBytesSync(bytes, flush: true);
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  Future<Result<bool, String>> coverSaveTo(String outpath) async {
    try {
      final bytes = coverBytes;
      if (bytes == null) {
        return Ok(false);
      }
      final f = File(outpath);
      await f.writeAsBytes(bytes, flush: true);
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
