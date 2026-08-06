import 'dart:typed_data';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:xml/xml.dart';

mixin InfoHandler on IEpubCoreEngine {
  Uint8List? getCoverBytes(EpubInfo info) {
    if (info.cover == null) return null;
    final mani = ctx.manifest[info.cover];
    if (mani == null) return null;
    String zipPath = mani.href;
    if (ctx.opfParentPath.isNotEmpty) {
      zipPath = '${ctx.opfParentPath}/${mani.href}';
    }
    return zipIoHandler.getFileBytes(zipPath);
  }

  /// ```xml
  ///    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
  ///     <dc:language>my</dc:language>
  ///     <dc:title>ဝါးမျိုခြင်းစာအုပ်</dc:title>
  ///     <dc:creator opf:role="aut">PSM</dc:creator>
  ///     <meta name="Sigil version" content="2.1.0"/>
  ///     <dc:date opf:event="modification" xmlns:opf="http://www.idpf.org/2007/opf">2024-05-04</dc:date>
  ///     <dc:identifier opf:scheme="UUID" id="BookId">urn:uuid:8906e440-08a1-4d25-8240-a02be5200ea2</dc:identifier>
  ///     <meta name="cover" content="a-1.jpg"/>
  ///   </metadata>
  ///
  /// ```
  EpubInfo loadInfo(String opfContent) {
    final xml = XmlDocument.parse(opfContent);

    const dcNs = 'http://purl.org/dc/elements/1.1/';
    const opfNs = 'http://www.idpf.org/2007/opf';

    final metadata = xml
        .findAllElements('metadata', namespaceUri: opfNs)
        .firstOrNull;

    if (metadata == null) return .new();

    String? text(String name) {
      return metadata
          .findElements(name, namespaceUri: dcNs)
          .firstOrNull
          ?.innerText
          .trim();
    }

    final creator = metadata
        .findElements('creator', namespaceUri: dcNs)
        .firstOrNull;

    final identifier = metadata
        .findElements('identifier', namespaceUri: dcNs)
        .firstOrNull;

    final date = metadata.findElements('date', namespaceUri: dcNs).firstOrNull;

    String? meta({required String name}) {
      return metadata
          .findElements('meta', namespaceUri: opfNs)
          .where((e) => e.getAttribute('name') == name)
          .firstOrNull
          ?.getAttribute('content');
    }

    return EpubInfo(
      language: text('language'),
      title: text('title'),

      creator: creator?.innerText.trim(),
      creatorRole: creator?.getAttribute('role', namespaceUri: opfNs),

      identifier: identifier?.innerText.trim(),
      identifierScheme: identifier?.getAttribute('scheme', namespaceUri: opfNs),

      date: date?.innerText.trim(),
      dateEvent: date?.getAttribute('event', namespaceUri: opfNs),

      cover: meta(name: 'cover'),
    );
  }
}
