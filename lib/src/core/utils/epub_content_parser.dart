import 'package:epub_engine/src/core/epub_core.dart';
import 'package:epub_engine/src/core/models/epub_manifest_item.dart';
import 'package:epub_engine/src/core/models/epub_metadata.dart';
import 'package:epub_engine/src/core/models/epub_spine_item.dart';
import 'package:epub_engine/src/core/result_t.dart';
import 'package:epub_engine/src/core/utils/xml_utils.dart';
import 'package:xml/xml.dart';

class EpubContentParser {
  static const dc = 'http://purl.org/dc/elements/1.1/';
  static const opf = 'http://www.idpf.org/2007/opf';

  static Result<bool, String> parse(IEpubCore core, String xmlString) {
    try {
      final xml = XmlDocument.parse(xmlString);
      final package = xml.rootElement;

      final meta = package.findAllElements('metadata', namespaceUri: opf).first;

      // DC metadata
      final title = XmlUtils.getInnerText(meta, 'title', namespaceUri: dc);

      final language = XmlUtils.getInnerTextList(
        meta,
        'language',
        namespaceUri: dc,
      );

      final creator = XmlUtils.getInnerTextList(
        meta,
        'creator',
        namespaceUri: dc,
      );

      final contributor = XmlUtils.getInnerTextList(
        meta,
        'contributor',
        namespaceUri: dc,
      );

      final identifier = XmlUtils.getInnerTextList(
        meta,
        'identifier',
        namespaceUri: dc,
      );

      // OPF <meta>
      final metaItems = meta
          .findAllElements('meta', namespaceUri: opf)
          .map(
            (e) => EpubMetaItem(
              name: e.getAttribute('name') ?? '',
              content: e.getAttribute('content') ?? '',
            ),
          )
          .toList();

      String coverId = '';

      for (final item in metaItems) {
        if (item.name == 'cover') {
          coverId = item.content;
          break;
        }
      }

      core.ctx.metadata = .new(
        title: title,
        language: language,
        creators: creator,
        contributor: contributor,
        identifiers: identifier,
        metaItems: metaItems,
        coverId: coverId,
      );

      _parseManifestItems(core, xml);
      _parseSpineItems(core, xml);

      return Ok(true);
    } catch (e) {
      return Err('[EpubContentParser:parse]: $e');
    }
  }

  static void _parseManifestItems(IEpubCore core, XmlDocument xml) {
    final manifests = xml.findAllElements('manifest', namespaceUri: opf);

    if (manifests.isEmpty) return;

    core.ctx.manifestItems = manifests.first
        .findAllElements('item', namespaceUri: opf)
        .map(
          (e) => EpubManifestItem(
            epubCore: core,
            id: e.getAttribute('id') ?? '',
            href: e.getAttribute('href') ?? '',
            mediaType: e.getAttribute('media-type') ?? '',
          ),
        )
        .toList();
  }

  static void _parseSpineItems(IEpubCore core, XmlDocument xml) {
    final spines = xml.findAllElements('spine', namespaceUri: opf);

    if (spines.isEmpty) return;

    core.ctx.spineItems = spines.first
        .findAllElements('itemref', namespaceUri: opf)
        .map(
          (e) => EpubSpineItem(
            epubCore: core,
            idref: e.getAttribute('idref') ?? '',
          ),
        )
        .toList();
  }
}
