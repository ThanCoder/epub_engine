import 'dart:isolate';
import 'dart:typed_data';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';

mixin InfoHandler on IEpubCoreEngine {
  EpubManifestItem? get _coverItem {
    EpubManifestItem? mani;

    /// cover ရှိရင် mani ထဲထည့်
    if (ctx.info.cover != null) {
      mani = ctx.manifest[ctx.info.cover];
    } else {
      // cover က မရှိရင်
      // meta ထဲမှာ properties: cover-image ရှိလားရှာကြည့်မယ်
      for (var item in ctx.manifest.values) {
        if (item.properties != null) {
          // cover ရှိနေတယ် loop ထဲက ထွက်
          mani = item;
          break;
        }
      }
    }
    return mani;
  }

  /// Get Cover Bytes
  Future<Uint8List?> get coverBytes async {
    if (_coverItem == null) return null;

    final href = Uri.decodeComponent(_coverItem!.href);
    String zipPath = href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${_coverItem!.href}';
    }
    final path = this.path;
    return await Isolate.run(() {
      final zip = ZipIoHandler();
      zip.loadSync(path);
      return zip.getFileBytes(zipPath);
    });
  }

  /// Save as Cover
  Future<bool> saveAsCover(String outpath) async {
    if (_coverItem == null) return false;

    final href = Uri.decodeComponent(_coverItem!.href);
    String zipPath = href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${_coverItem!.href}';
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
    if (_coverItem == null) return null;

    final href = Uri.decodeComponent(_coverItem!.href);
    String zipPath = href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${_coverItem!.href}';
    }
    return zipAsynIo.getFileBytes(zipPath);
  }

  bool saveAsCoverSync(String outpath) {
    if (_coverItem == null) return false;

    final href = Uri.decodeComponent(_coverItem!.href);
    String zipPath = href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${_coverItem!.href}';
    }
    return zipAsynIo.writeAsFile(zipPath, outpath);
  }
}
