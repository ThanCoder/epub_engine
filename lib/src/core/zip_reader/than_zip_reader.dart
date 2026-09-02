// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:epub_engine/src/core/result_t.dart';
// import 'package:epub_engine/src/core/zip_reader/i_epub_zip_reader.dart';

// class ThanZipReader implements IEpubZipReader {
//   final _z = ZipReader();
//   @override
//   void close() {
//     _z.close();
//   }

//   @override
//   int get count => _z.count;

//   @override
//   Uint8List? getContent(String name) {
//     final index = _z.list.indexWhere((e) => e.filename == name);
//     if (index == -1) return null;
//     return _z.list[index].readBytes;
//   }

//   @override
//   String? getContentText(String name) {
//     final index = _z.list.indexWhere((e) => e.filename == name);
//     if (index == -1) return null;
//     return utf8.decode(_z.list[index].readBytes);
//   }

//   @override
//   List<String> get names => _z.list.map((e) => e.filename).toList();

//   @override
//   Result<bool, String> open(String path) {
//     final res = _z.open(path);
//     if (res.isErr) {
//       return Err(res.unwrapError());
//     }
//     return Ok(res.unwrap());
//   }
// }
