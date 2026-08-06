import 'package:xml/xml.dart';

class XmlUtils {
  static String? getFullpathFromContainerXml(String xmlContent) {
    final xml = XmlDocument.parse(xmlContent);
    final rootFile = xml.findAllElements('rootfile').firstOrNull;
    if (rootFile != null) {
      return rootFile.getAttribute('full-path');
    }

    return null;
  }
}
