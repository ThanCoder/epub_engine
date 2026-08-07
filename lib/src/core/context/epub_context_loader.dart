// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:xml/xml.dart';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/context/epub_context.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';
import 'package:epub_engine/src/utils/xml_utils.dart';

class EpubContextLoader {
  final ZipIoHandler zipIoHandler;
  EpubContext? ctx;
  EpubContextLoader({required this.zipIoHandler, this.ctx});

  bool openSync(String path, {String? password}) {
    try {
      final zipPathList = <String>[];
      String opfPath = '';
      String opfParentPath = '';
      String mimetype = '';
      List<EpubTocItem> toc = [];
      // scan zip
      zipIoHandler.loadSync(
        path,
        password: password,
        callback: (entry) {
          if (!entry.isFile) return;
          zipPathList.add(entry.name);
          if (entry.name.endsWith('mimetype')) {
            mimetype = utf8.decode(entry.content);
          }
          // print(entry.name);
          if (entry.name == 'META-INF/container.xml') {
            final fullpath = XmlUtils.getFullpathFromContainerXml(
              utf8.decode(entry.content),
            );
            if (fullpath != null) {
              opfPath = fullpath;
              final parts = fullpath.split('/');
              parts.removeLast();
              opfParentPath = parts.join('/');
            }
          }
          // search toc
          if (entry.name.endsWith('toc.ncx')) {
            final content = utf8.decode(entry.content);
            toc = loadToc(content);
          }
        },
      );

      final opfContent = zipIoHandler.getFileContent(opfPath);
      if (opfContent == null) {
        throw const FormatException(
          'EPUB package document (content.opf) not found.',
        );
      }

      final manifest = <String, EpubManifestItem>{};
      loadManifest(opfContent, manifest);

      List<EpubSpineItem> spine = loadSpine(
        opfContent,
        manifest,
        opfParentPath,
      );

      EpubInfo info = loadInfo(opfContent);

      ctx = .new(
        zipPathList: zipPathList,
        opfPath: opfPath,
        opfParentPath: opfParentPath,
        mimetype: mimetype,
        info: info,
        manifest: manifest,
        spine: spine,
        toc: toc,
      );
      return true;
    } catch (e) {
      print('[EpubContextLoader:openSync]: $e');
      return false;
    }
  }

  EpubInfo loadInfo(String opfContent) {
    final xml = XmlDocument.parse(opfContent);

    String? version;
    // package
    final package = xml.findAllElements('package').firstOrNull;
    if (package != null) {
      version = package.getAttribute('version');
    }

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
      version: version,
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

  void loadManifest(String opfContent, Map<String, EpubManifestItem> manifest) {
    if (opfContent.isEmpty) return;

    final xml = XmlDocument.parse(opfContent);

    const opfNs = 'http://www.idpf.org/2007/opf';

    final manifestElements = xml
        .findAllElements('manifest', namespaceUri: opfNs)
        .firstOrNull;

    final spineElement = xml
        .findAllElements('spine', namespaceUri: opfNs)
        .firstOrNull;

    if (manifestElements == null || spineElement == null) {
      return;
    }

    for (final item in manifestElements.findElements(
      'item',
      namespaceUri: opfNs,
    )) {
      final id = item.getAttribute('id');
      final href = item.getAttribute('href');
      final mediaType = item.getAttribute('media-type');
      final properties = item.getAttribute('properties');

      if (id == null || href == null || mediaType == null) {
        continue;
      }

      manifest[id] = EpubManifestItem(
        id: id,
        href: href,
        mediaType: mediaType,
        properties: properties,
      );
    }
  }

  List<EpubSpineItem> loadSpine(
    String opfData,
    Map<String, EpubManifestItem> manifest,
    String opfParentPath,
  ) {
    const opfNs = 'http://www.idpf.org/2007/opf';

    final xml = XmlDocument.parse(opfData);

    final spine = xml.findAllElements('spine', namespaceUri: opfNs).firstOrNull;

    if (spine == null) {
      return const [];
    }

    final result = <EpubSpineItem>[];

    for (final itemref in spine.findElements('itemref', namespaceUri: opfNs)) {
      final idref = itemref.getAttribute('idref');

      if (idref == null) continue;

      final item = manifest[idref];

      if (item == null) continue;

      // final path = p.normalize(p.join(opfParentPath, item.href));
      String path = item.href;
      if (opfParentPath.isNotEmpty) {
        path = '$opfParentPath/${item.href}';
      }
      result.add(
        EpubSpineItem(
          idref: idref,
          id: item.id,
          href: item.href,
          mediaType: item.mediaType,
          index: result.length,
          linear: itemref.getAttribute('linear') != 'no',
          path: path,
        ),
      );
    }

    return result;
  }

  /// load toc
  List<EpubTocItem> loadToc(String ncxContent) {
    if (ncxContent.isEmpty) return const [];

    final xml = XmlDocument.parse(ncxContent);

    const ncxNs = 'http://www.daisy.org/z3986/2005/ncx/';

    final navMap = xml
        .findAllElements('navMap', namespaceUri: ncxNs)
        .firstOrNull;

    if (navMap == null) {
      return const [];
    }

    return _parseNavPoints(
      navMap.findElements('navPoint', namespaceUri: ncxNs),
      ncxNs,
    );
  }

  List<EpubTocItem> _parseNavPoints(
    Iterable<XmlElement> elements,
    String namespaceUri,
  ) {
    return elements.map((element) {
      final navLabel = element
          .findElements('navLabel', namespaceUri: namespaceUri)
          .firstOrNull;

      final text = navLabel
          ?.findElements('text', namespaceUri: namespaceUri)
          .firstOrNull
          ?.innerText
          .trim();

      final content = element
          .findElements('content', namespaceUri: namespaceUri)
          .firstOrNull;

      final children = _parseNavPoints(
        element.findElements('navPoint', namespaceUri: namespaceUri),
        namespaceUri,
      );

      return EpubTocItem(
        id: element.getAttribute('id') ?? '',
        playOrder: int.tryParse(element.getAttribute('playOrder') ?? ''),
        title: text ?? '',
        src: content?.getAttribute('src') ?? '',
        children: children,
      );
    }).toList();
  }
}
