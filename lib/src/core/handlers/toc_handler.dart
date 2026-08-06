import 'dart:isolate';

import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';
import 'package:epub_engine/src/models/epub_toc_item.dart';

mixin TocHandler on IEpubCoreEngine {
  /// Toc Content
  Future<String?> getTocContent(EpubTocItem item) async {
    String zipPath = item.src;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${item.src}';
    }

    final path = this.path;
    return await Isolate.run(() {
      final zip = ZipIoHandler();
      zip.loadSync(path);
      return zip.getFileContent(zipPath);
    });
  }

  /// Toc Content
  String? getTocContentSync(EpubTocItem item) {
    String zipPath = item.src;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${item.src}';
    }
    return zipAsynIo.getFileContent(zipPath);
  }
}
