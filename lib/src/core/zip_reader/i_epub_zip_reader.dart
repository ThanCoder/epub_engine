import 'dart:typed_data';

import 'package:epub_engine/src/core/result_t.dart';

abstract class IEpubZipReader {
  Result<bool, String> open(String path);
  void close();
  int get count;
  List<String> get names;
  Uint8List? getContent(String name);
  String? getContentText(String name);
}
