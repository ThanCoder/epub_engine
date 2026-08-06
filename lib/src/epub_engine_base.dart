// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/core_engine.dart';
import 'package:epub_engine/src/core/context/epub_context.dart';

class EpubEngine {
  final _core = CoreEngine();

  /// ### Book Context
  EpubContext get ctx => _core.ctx;

  /// Epub Book Info
  EpubInfo get info => _core.ctx.info;

  /// Epub Chapter List
  List<EpubChapter> get chapters => _core.getChapters();

  /// Epub Manifest Items
  Map<String, EpubManifestItem> get manifest => _core.ctx.manifest;

  /// Epub Table of Contents
  List<EpubTocItem> get toc => _core.ctx.toc;

  /// Epub Reading Order
  List<EpubSpineItem> get spine => _core.ctx.spine;

  /// Close Book
  void dispose() {
    _core.dispose();
  }

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
