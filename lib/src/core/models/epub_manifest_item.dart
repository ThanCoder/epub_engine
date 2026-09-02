import 'dart:io';
import 'dart:typed_data';

import 'package:epub_engine/src/core/epub_core.dart';
import 'package:epub_engine/src/core/result_t.dart';

class EpubManifestItem {
  const EpubManifestItem({
    required this._epubCore,
    required this.id,
    required this.href,
    required this.mediaType,
  });
  final String id;
  final String href;
  final String mediaType;
  final IEpubCore _epubCore;

  @override
  String toString() =>
      'EpubManifestItem(id: $id, href: $href, mediaType: $mediaType)';
}

extension EpubManifestItemExt on EpubManifestItem {
  String get filename {
    return href.split('/').last;
  }

  String get fullPathByHref {
    return _epubCore.getFullPathByHref(href);
  }

  String? get contentText {
    return _epubCore.reader.getContentText(fullPathByHref);
  }

  Uint8List? get content {
    return _epubCore.reader.getContent(fullPathByHref);
  }

  Result<bool, String> saveAsFileSync(String path) {
    try {
      final bytes = _epubCore.reader.getContent(fullPathByHref);
      if (bytes == null) return Ok(false);
      final f = File(path);
      f.writeAsBytesSync(bytes, flush: true);
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  Future<Result<bool, String>> saveAsFile(String path) async {
    try {
      final bytes = _epubCore.reader.getContent(fullPathByHref);
      if (bytes == null) return Ok(false);
      final f = File(path);
      await f.writeAsBytes(bytes, flush: true);
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
