// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epub_engine/src/core/models/epub_manifest_item.dart';
import 'package:epub_engine/src/core/models/epub_metadata.dart';
import 'package:epub_engine/src/core/models/epub_ncx.dart';
import 'package:epub_engine/src/core/models/epub_spine_item.dart';

class EpubCtx {
  String contentFullpath = '';
  String rootPath = '';
  EpubMetadata metadata = .new();
  List<EpubManifestItem> manifestItems = [];
  List<EpubSpineItem> spineItems = [];
  EpubNcx ncx = .new();

  @override
  String toString() =>
      'EpubCtx(contentFullpath: $contentFullpath, rootPath: $rootPath)';
}
