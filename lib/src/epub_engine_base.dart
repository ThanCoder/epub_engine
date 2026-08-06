// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/core_engine.dart';
import 'package:epub_engine/src/core/epub_context.dart';
import 'package:epub_engine/src/models/epub_toc_item.dart';

class EpubEngine {
  final _core = CoreEngine();

  EpubContext get ctx => _core.ctx;

  /// Get Chapter Content
  String getChapterContent(EpubChapter chapter) =>
      _core.getChapterContent(chapter);

  /// Get Toc Content
  String? getTocContent(EpubTocItem item) => _core.getTocContent(item);

  /// Epub Chapter List
  List<EpubChapter> get getChapters => _core.getChapters();

  EpubInfo get info => _core.ctx.info;

  /// Cover Bytes
  Uint8List? get getCoverBytes => _core.getCoverBytes(_core.ctx.info);

  /// Return -> `bool` if `true` ? `writed` : `no write`.
  bool saveAsCoverSync(String outpath, {bool isOverride = true}) {
    final file = File(outpath);
    if (!isOverride && file.existsSync()) return false;
    final bytes = getCoverBytes;
    if (bytes != null) {
      file.writeAsBytesSync(bytes);
    }
    return true;
  }

  /// Return -> `bool` if `true` ? `writed` : `no write`.
  Future<bool> saveAsCover(String outpath, {bool isOverride = true}) async {
    final file = File(outpath);
    if (!isOverride && file.existsSync()) return false;
    final bytes = getCoverBytes;
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return true;
  }

  /// Open Epub Book
  void open(String path) {
    _core.open(path);
  }

  /// Close Book
  void dispose() {
    _core.dispose();
  }
}
