part of 'epub_core.dart';

sealed class IEpubCore {
  final ctx = EpubCtx();
  IEpubZipReader get reader;

  Result<bool, String> open(String path) {
    final res = reader.open(path);
    if (res.isErr) {
      return Err(res.unwrapError());
    }
    loadInfo();
    return Ok(true);
  }

  Result<bool, String> loadInfo();

  void close() {
    reader.close();
  }
}
