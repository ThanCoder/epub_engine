import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:xml/xml.dart';

class XmlParser implements IXmlParser {
  const XmlParser();
  
  @override
  List<XmlElement> findAllElements(String xmlContent, String tagName) {
    final xml = XmlDocument.parse(xmlContent);
    final eles = xml.findAllElements(tagName).toList();
    return eles;
  }

  @override
  String? getAttribute(XmlElement element, String attributeName) {
    return element.getAttribute(attributeName);
  }

  @override
  String? queryAttribute(
    String xmlContent,
    String tagName,
    String attributeName,
  ) {
    final xml = XmlDocument.parse(xmlContent);
    final ele = xml.findAllElements(tagName).firstOrNull;
    if (ele != null) {
      return ele.getAttribute(attributeName);
    }
    return null;
  }

  @override
  String? queryTagValue(String xmlContent, String tagName) {
    final xml = XmlDocument.parse(xmlContent);
    final ele = xml.findAllElements(tagName).firstOrNull;
    if (ele != null) {
      return ele.innerText;
    }
    return null;
  }
}
