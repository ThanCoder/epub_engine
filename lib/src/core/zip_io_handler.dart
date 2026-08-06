import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

class ZipIoHandler {
  Archive? archive;

  void loadSync(
    String path, {
    String? password,
    void Function(ArchiveFile entry)? callback,
  }) {
    archive = ZipDecoder().decodeStream(
      InputFileStream(path),
      password: password,
      callback: callback,
    );
  }

  void close() {
    archive = null;
  }

  Uint8List? getFileBytes(String innerPath) {
    final arch = archive;
    if (arch == null) return null;

    for (final file in arch) {
      if (!file.isFile) continue;

      if (file.name == innerPath) {
        return file.content;
      }
    }

    return null;
  }

  String? getFileContent(String innerPath) {
    final bytes = getFileBytes(innerPath);

    if (bytes == null || bytes.isEmpty) {
      return null;
    }

    return utf8.decode(bytes);
  }

  List<String> getInnerPathList() {
    final arch = archive;
    if (arch == null) return [];

    return arch.files.map((e) => e.name).toList();
  }

  bool writeAsFile(String innerPath, String outpath) {
    final arch = archive;
    if (arch == null) return false;

    final file = arch.find(innerPath);
    if (file == null) return false;

    final output = OutputFileStream(outpath);

    try {
      file.writeContent(output);
      return true;
    } finally {
      output.closeSync();
    }
  }
}
