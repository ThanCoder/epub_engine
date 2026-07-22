import 'dart:typed_data';

import 'package:xml/xml.dart';

abstract class IZipIoHandler {
  void load(String path);
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
  void open(String path);
  void dispose();

  IZipIoHandler get zipIoHandler;
  IXmlParser get xmlParser;
}
