import 'package:epub_engine/src/core/context/epub_context.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';

abstract class IEpubCoreEngine {
  String get path;

  /// ### Open Book
  ///
  /// Return -> `bool`
  ///
  /// `true` ? `opened` : `open failed!`
  Future<bool> open(String path, {String? password});
  bool openSync(String path, {String? password});

  /// ### Close Book
  void dispose();

  /// Book Context
  EpubContext get ctx;

  ZipIoHandler get zipAsynIo;
}
