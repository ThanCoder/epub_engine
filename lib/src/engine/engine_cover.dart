import 'dart:typed_data';

import 'package:epub_engine/src/core/epub_core.dart';
import 'package:epub_engine/src/core/result_t.dart';

class EngineCover {
  final EpubCore _core;
  const EngineCover(this._core);

  String get coverPath => _core.coverPath;

  Future<Result<bool, String>> saveTo(String outpath) async {
    return await _core.coverSaveTo(outpath);
  }

  Result<bool, String> saveToSync(String outpath) {
    return _core.coverSaveToSync(outpath);
  }

  Uint8List? get bytes {
    return _core.coverBytes;
  }
}
