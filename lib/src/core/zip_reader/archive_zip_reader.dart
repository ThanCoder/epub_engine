import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:epub_engine/src/core/result_t.dart';
import 'package:epub_engine/src/core/zip_reader/i_epub_zip_reader.dart';

class ArchiveZipReader implements IEpubZipReader {
  late Archive _archive;

  @override
  void close() {}

  @override
  int get count => _archive.length;

  @override
  Uint8List? getContent(String name) {
    final index = _archive.files.indexWhere(
      (e) => e.name == Uri.decodeComponent(name),
    );
    if (index == -1) return null;
    return _archive.files[index].content;
  }

  @override
  String? getContentText(String name) {
    final index = _archive.files.indexWhere(
      (e) => e.name == Uri.decodeComponent(name),
    );
    if (index == -1) return null;
    return utf8.decode(_archive.files[index].content);
  }

  @override
  List<String> get names => _archive.files.map((e) => e.name).toList();

  @override
  Result<bool, String> open(String path) {
    try {
      final inputStream = InputFileStream(path);
      _archive = ZipDecoder().decodeStream(inputStream);
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
