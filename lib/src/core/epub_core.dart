import 'dart:typed_data';

import 'package:epub_engine/src/core/epub_ctx.dart';
import 'package:epub_engine/src/core/result_t.dart';
import 'package:epub_engine/src/core/utils/epub_content_parser.dart';
import 'package:epub_engine/src/core/utils/xml_utils.dart';
import 'package:epub_engine/src/core/zip_reader/archive_zip_reader.dart';
import 'package:epub_engine/src/core/zip_reader/i_epub_zip_reader.dart';

part 'i_epub_core.dart';
part 'logics/info_logic.dart';
part 'logics/cover_logic.dart';

class EpubCore extends IEpubCore with InfoLogic, CoverLogic {
  @override
  final IEpubZipReader reader = ArchiveZipReader();
}
