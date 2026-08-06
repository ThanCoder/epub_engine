import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epub_engine/src/core/epub_context.dart';
import 'package:xml/xml.dart';

abstract class IZipIoHandler {
  void load(
    String path, {
    String? password,
    void Function(ArchiveFile entry)? callback,
  });
  Uint8List? getFileBytes(String innerPath);
  String? getFileContent(String innerPath);
  List<String> getInnerPathList();
  bool writeAsFile(String name, String outpath);
  void close();
}

abstract class IXmlParser {
  List<XmlElement> findAllElements(String xmlContent, String tagName);
  String? queryTagValue(String xmlContent, String tagName);
  String? queryAttribute(
    String xmlContent,
    String tagName,
    String attributeName,
  );
  String? getAttribute(XmlElement element, String attributeName);
}

abstract class IEpubCoreEngine {
  void open(String path, {String? password});
  void dispose();

  EpubContext get ctx;

  IZipIoHandler get zipIoHandler;
  IXmlParser get xmlParser;
}
