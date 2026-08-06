import 'dart:isolate';

import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';
import 'package:epub_engine/src/models/epub_chapter.dart';

mixin ChapterHandler on IEpubCoreEngine {
  /// Chapter Content
  Future<String?> getChapterContent(EpubChapter chapter) async {
    String zipPath = chapter.href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${chapter.href}';
    }

    final path = this.path;
    return await Isolate.run(() {
      final zip = ZipIoHandler();
      zip.loadSync(path);
      return zip.getFileContent(zipPath);
    });
  }

  /// Chapter Content
  String? getChapterContentSync(EpubChapter chapter) {
    String zipPath = chapter.href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${chapter.href}';
    }
    return zipAsynIo.getFileContent(zipPath);
  }

  /// Chapter Item
  List<EpubChapter> getChapters() {
    if (ctx.manifest.isEmpty) return [];

    final chapters = <EpubChapter>[];

    for (var item in ctx.spine) {
      chapters.add(
        EpubChapter(
          id: item.id,
          href: item.href,
          mediaType: item.mediaType,
          index: chapters.length,
          linear: item.linear,
        ),
      );
    }

    return chapters;
  }
}
