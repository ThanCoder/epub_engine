part of '../epub_engine_base.dart';

mixin SyncHandler on IEpubEngineBase {
  //*****************Sync Version*********************** */

  /// ### Open Epub Book
  ///
  /// Open Sync Version
  ///
  /// Used Sync Version
  bool openSync(String path) {
    return _core.openSync(path);
  }

  /// Get Chapter Content
  ///
  /// Open Sync Version
  String? getChapterContentSync(EpubChapter chapter) =>
      _core.getChapterContentSync(chapter);

  /// Get Toc Content
  ///
  /// Open Sync Version
  String? getTocContentSync(EpubTocItem item) => _core.getTocContentSync(item);

  /// Return -> `bool` if `true` ? `writed` : `no write`.
  ///
  /// Open Sync Version
  ///
  bool saveAsCoverSync(String outpath, {bool isOverride = true}) {
    final file = File(outpath);
    if (!isOverride && file.existsSync()) return false;
    return _core.saveAsCoverSync(outpath);
  }
}
