import 'package:epub_engine/src/core/epub_ctx.dart';
import 'package:epub_engine/src/core/models/epub_manifest_item.dart';
import 'package:epub_engine/src/core/models/epub_metadata.dart';
import 'package:epub_engine/src/core/models/epub_ncx.dart';
import 'package:epub_engine/src/core/models/epub_spine_item.dart';

class EngineCtx {
  final EpubCtx _ctx;
  const EngineCtx(this._ctx);

  String get contentFullpath => _ctx.contentFullpath;
  String get rootPath => _ctx.rootPath;
  EpubMetadata get metadata => _ctx.metadata;
  EpubNcx get ncx => _ctx.ncx;
  List<EpubManifestItem> get manifestItems => _ctx.manifestItems;
  List<EpubSpineItem> get spineItems => _ctx.spineItems;
}
