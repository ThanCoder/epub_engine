// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../epub_engine_base.dart';

mixin ZipIoHelper on IEpubEngineBase {
  bool saveAsFileWithZipInnerPath(String zipInnerfullPath, String outpath) {
    return _core.zipAsynIo.writeAsFile(zipInnerfullPath, outpath);
  }

  Uint8List? getFileBytesWithZipInnerPath(String zipInnerfullPath) {
    return _core.zipAsynIo.getFileBytes(zipInnerfullPath);
  }

  Future<void> resolveCaches(List<CachePathResolver> resolverList) async {
    final path = _core.path;

    await Isolate.run(() {
      final zip = ZipIoHandler();
      zip.loadSync(path);

      try {
        for (final res in resolverList) {
          final file = File(res.cacheFullpathPath);

          file.parent.createSync(recursive: true);

          if (!file.existsSync()) {
            zip.writeAsFile(res.zipInnerPath, res.cacheFullpathPath);
          }
        }
      } finally {
        zip.close();
      }
    });
  }
}

class CachePathResolver {
  final String zipInnerPath;
  final String cacheFullpathPath;
  const CachePathResolver({
    required this.zipInnerPath,
    required this.cacheFullpathPath,
  });

  @override
  String toString() =>
      'CachePathResolver(zipInnerPath: $zipInnerPath, cacheFullpathPath: $cacheFullpathPath)';
}
