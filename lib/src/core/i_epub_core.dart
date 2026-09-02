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

  String getFullPathByHref(String href) {
    if (ctx.rootPath.isNotEmpty) {
      return '${ctx.rootPath}/$href';
    }
    return href;
  }

  String getFullPathByItem(EpubManifestItem item) {
    return getFullPathByHref(item.href);
  }

  Result<bool, String> loadInfo();

  void close() {
    reader.close();
  }
}
