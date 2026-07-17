// ignore_for_file: implementation_imports
import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/core/xml_parser.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';

class CoreEngine implements IEpubCoreEngine {
  @override
  void dispose() {
    zipIoHandler.close();
  }

  @override
  void open(String path) {
    zipIoHandler.load(path);
  }

  @override
  final IXmlParser xmlParser = XmlParser();

  @override
  final IZipIoHandler zipIoHandler = ZipIoHandler();
}
