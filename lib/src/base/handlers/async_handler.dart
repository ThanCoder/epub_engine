part of '../epub_engine_base.dart';

mixin AsyncHandler on IEpubEngineBase {
  //*****************ASync Version*********************** */

  /// ### Open Epub Book
  ///
  /// Async Version
  Future<bool> open(String path) async {
    return _core.open(path);
  }

  /// Epub Chapter List
  ///
  /// Get Chapter Content
  Future<String?> getChapterContent(EpubChapter chapter) async =>
      await _core.getChapterContent(chapter);

  /// Get Toc Content
  ///
  /// Epub Table of Contents
  Future<String?> getTocContent(EpubTocItem item) async =>
      await _core.getTocContent(item);

  /// Cover Bytes
  Future<Uint8List?> get coverBytes async => await _core.coverBytes;

  /// Used Sync Version
  Uint8List? get coverBytesSync => _core.coverBytesSync;

  /// Return -> `bool` if `true` ? `writed` : `no write`.
  Future<bool> saveAsCover(String outpath, {bool isOverride = true}) async {
    final file = File(outpath);
    if (!isOverride && file.existsSync()) return false;
    return await _core.saveAsCover(outpath);
  }
}
