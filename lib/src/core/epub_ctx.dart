// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epub_engine/src/core/models/epub_metadata.dart';

class EpubCtx {
  String contentFullpath = '';
  String rootPath = '';
  EpubMetadata metadata = .new();
  List<EpubManifestItem> manifestItems = [];
  List<EpubSpineItem> spineItems = [];

  @override
  String toString() =>
      'EpubCtx(contentFullpath: $contentFullpath, rootPath: $rootPath)';
}
