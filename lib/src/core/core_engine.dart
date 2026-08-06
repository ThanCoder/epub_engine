import 'dart:convert';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/epub_context.dart';
import 'package:epub_engine/src/core/handlers/chapter_handler.dart';
import 'package:epub_engine/src/core/handlers/info_handler.dart';
import 'package:epub_engine/src/core/handlers/manifest_handler.dart';
import 'package:epub_engine/src/core/handlers/spine_handler.dart';
import 'package:epub_engine/src/core/handlers/toc_handler.dart';
import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/core/xml_parser.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';
import 'package:epub_engine/src/models/epub_manifest_item.dart';
import 'package:epub_engine/src/models/epub_spine_item.dart';
import 'package:epub_engine/src/models/epub_toc_item.dart';
import 'package:epub_engine/src/utils/xml_utils.dart';

class CoreEngine extends IEpubCoreEngine
    with
        ManifestHandler,
        InfoHandler,
        ChapterHandler,
        TocHandler,
        SpineHandler {
  @override
  void dispose() {
    zipIoHandler.close();
  }

  @override
  void open(String path, {String? password}) {
    final zipPathList = <String>[];
    String opfPath = '';
    String opfParentPath = '';
    String mimetype = '';
    List<EpubTocItem> toc = [];
    // scan zip
    zipIoHandler.load(
      path,
      password: password,
      callback: (entry) {
        if (!entry.isFile) return;
        zipPathList.add(entry.name);
        if (entry.name.endsWith('mimetype')) {
          mimetype = utf8.decode(entry.content);
        }
        // print(entry.name);
        if (entry.name == 'META-INF/container.xml') {
          final fullpath = XmlUtils.getFullpathFromContainerXml(
            utf8.decode(entry.content),
          );
          if (fullpath != null) {
            opfPath = fullpath;
            final parts = fullpath.split('/');
            parts.removeLast();
            opfParentPath = parts.join('/');
          }
        }
        if (entry.name.endsWith('toc.ncx')) {
          final content = utf8.decode(entry.content);
          toc = loadToc(content);
        }
      },
    );

    final opfContent = zipIoHandler.getFileContent(opfPath);
    if (opfContent == null) {
      throw const FormatException(
        'EPUB package document (content.opf) not found.',
      );
    }

    final manifest = <String, EpubManifestItem>{};
    loadManifest(opfContent, manifest);

    List<EpubSpineItem> spine = loadSpine(opfContent, manifest, opfParentPath);

    EpubInfo info = loadInfo(opfContent);

    ctx = .new(
      zipPathList: zipPathList,
      opfPath: opfPath,
      opfParentPath: opfParentPath,
      mimetype: mimetype,
      info: info,
      manifest: manifest,
      spine: spine,
      toc: toc,
    );
  }

  @override
  late final EpubContext ctx;

  @override
  final IXmlParser xmlParser = XmlParser();

  @override
  final IZipIoHandler zipIoHandler = ZipIoHandler();
}
