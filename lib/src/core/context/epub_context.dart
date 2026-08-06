// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epub_engine/epub_engine.dart';

class EpubContext {
  final List<String> zipPathList;

  /// OEBPS/content.opf
  final String opfPath;

  /// OEBPS
  final String opfParentPath;

  final String mimetype;

  final EpubInfo info;

  final Map<String, EpubManifestItem> manifest;

  final List<EpubSpineItem> spine;

  final List<EpubTocItem> toc;

  const EpubContext({
    required this.zipPathList,
    required this.opfPath,
    required this.opfParentPath,
    required this.mimetype,
    required this.info,
    required this.manifest,
    required this.spine,
    required this.toc,
  });
}
