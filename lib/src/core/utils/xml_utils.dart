import 'package:xml/xml.dart';

class XmlUtils {
  static String getContentFullpath(String xmlStr) {
    final xml = XmlDocument.parse(xmlStr);
    final res = xml.findAllElements('rootfile');
    if (res.isEmpty) return '';
    return res.first.getAttribute('full-path') ?? '';
  }

  static String getInnerText(XmlElement xml, String name) {
    final res = xml.findAllElements(name);
    if (res.isEmpty) return '';
    return res.first.innerText;
  }

  static List<String> getInnerTextList(XmlElement xml, String name) {
    final res = xml.findAllElements(name);
    return res.map((e) => e.innerText).toList();
  }
}
