import 'dart:isolate';

import 'package:epub_engine/src/core/context/epub_context.dart';
import 'package:epub_engine/src/core/context/epub_context_loader.dart';
import 'package:epub_engine/src/core/handlers/chapter_handler.dart';
import 'package:epub_engine/src/core/handlers/info_handler.dart';
import 'package:epub_engine/src/core/handlers/toc_handler.dart';
import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';

class CoreEngine extends IEpubCoreEngine
    with InfoHandler, ChapterHandler, TocHandler {
  @override
  void dispose() {}

  String _path = '';

  @override
  String get path => _path;

  @override
  Future<bool> open(String path, {String? password}) async {
    _path = path;
    EpubContext? ctx = await Isolate.run(() {
      final loader = EpubContextLoader(zipIoHandler: ZipIoHandler());
      if (loader.openSync(path)) {
        return loader.ctx;
      }
      return null;
    });

    if (ctx == null) return false;
    this.ctx = ctx;

    return true;
  }

  @override
  bool openSync(String path, {String? password}) {
    _path = path;
    // zipAsynIo.loadSync(path);
    final loader = EpubContextLoader(zipIoHandler: zipAsynIo);
    if (!loader.openSync(path)) {
      return false;
    }

    ctx = loader.ctx!;
    return true;
  }

  @override
  late final EpubContext ctx;

  @override
  late final zipAsynIo = ZipIoHandler();
}
