import 'dart:typed_data';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/epub_core.dart';

class EpubSpineItem {
  const EpubSpineItem({required this.idref, required this._epubCore});
  final IEpubCore _epubCore;
  final String idref;

  @override
  String toString() => 'EpubSpineItem(idref: $idref)';
}

extension EpubSpineItemExt on EpubSpineItem {
  int get manifestItemsIndex =>
      _epubCore.ctx.manifestItems.indexWhere((e) => e.id == idref);

  EpubManifestItem? get toManifestItem {
    final index = manifestItemsIndex;
    if (index == -1) return null;
    return _epubCore.ctx.manifestItems[index];
  }

  Uint8List? get content {
    final index = manifestItemsIndex;
    if (index == -1) return null;
    final item = _epubCore.ctx.manifestItems[index];
    return item.content;
  }

  String? get contentText {
    final index = manifestItemsIndex;
    if (index == -1) return null;
    final item = _epubCore.ctx.manifestItems[index];
    return item.contentText;
  }
}
