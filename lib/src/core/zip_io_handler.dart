import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_engine/src/core/i_epub_core_engine.dart';

class ZipIoHandler implements IZipIoHandler {
  ZipIoHandler();

  late Archive? archive;

  @override
  void close() {
    print('zip closed');
  }

  @override
  Uint8List? getFileBytes(String innerPath) {
    for (var file in archive!) {
      if (!file.isFile) continue;
      if (file.name == innerPath) {
        return file.content;
      }
    }
    return null;
  }

  @override
  void load(String path) {
    archive = ZipDecoder().decodeStream(InputFileStream(path));
    print('Zip loaded successfully.');
  }

  @override
  String? getFileContent(String innerPath) {
    final bytes = getFileBytes(innerPath);
    if (bytes != null && bytes.isNotEmpty) {
      return utf8.decode(bytes);
    }
    return null;
  }
}
