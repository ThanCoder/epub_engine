import 'dart:isolate';
import 'dart:typed_data';

import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';

mixin InfoHandler on IEpubCoreEngine {
  /// Get Cover Bytes
  Future<Uint8List?> get coverBytes async {
    if (ctx.info.cover == null) return null;
    final mani = ctx.manifest[ctx.info.cover];
    if (mani == null) return null;

    final href = Uri.decodeComponent(mani.href);
    String zipPath = href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${mani.href}';
    }
    // return zipIoHandler.getFileBytes(zipPath);
    final path = this.path;
    return await Isolate.run(() {
      final zip = ZipIoHandler();
      zip.loadSync(path);
      return zip.getFileBytes(zipPath);
    });
  }

  /// Save as Cover
  Future<bool> saveAsCover(String outpath) async {
    if (ctx.info.cover == null) return false;
    final mani = ctx.manifest[ctx.info.cover];
    if (mani == null) return false;

    final href = Uri.decodeComponent(mani.href);
    String zipPath = href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${mani.href}';
    }
    // return zipIoHandler.writeAsFile(zipPath, outpath);
    final path = this.path;
    return await Isolate.run(() {
      final zip = ZipIoHandler();
      zip.loadSync(path);
      return zip.writeAsFile(zipPath, outpath);
    });
  }
  //****************Sync********************//

  Uint8List? get coverBytesSync {
    if (ctx.info.cover == null) return null;
    final mani = ctx.manifest[ctx.info.cover];
    if (mani == null) return null;

    final href = Uri.decodeComponent(mani.href);
    String zipPath = href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${mani.href}';
    }
    return zipAsynIo.getFileBytes(zipPath);
  }

  bool saveAsCoverSync(String outpath) {
    if (ctx.info.cover == null) return false;
    final mani = ctx.manifest[ctx.info.cover];
    if (mani == null) return false;

    final href = Uri.decodeComponent(mani.href);
    String zipPath = href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${mani.href}';
    }
    return zipAsynIo.writeAsFile(zipPath, outpath);
  }
}
