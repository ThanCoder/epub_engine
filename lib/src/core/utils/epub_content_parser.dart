import 'package:epub_engine/src/core/epub_ctx.dart';
import 'package:epub_engine/src/core/models/epub_metadata.dart';
import 'package:epub_engine/src/core/result_t.dart';
import 'package:epub_engine/src/core/utils/xml_utils.dart';
import 'package:xml/xml.dart';

class EpubContentParser {
  static Result<bool, String> parse(EpubCtx ctx, String xmlString) {
    try {
      final xml = XmlDocument.parse(xmlString);
      final meta = xml.findAllElements('metadata').first;

      final title = XmlUtils.getInnerText(meta, 'dc:title');
      final language = XmlUtils.getInnerText(meta, 'dc:language');
      final creator = XmlUtils.getInnerTextList(meta, 'dc:creator');
      final contributor = XmlUtils.getInnerText(meta, 'dc:contributor');
      final identifier = XmlUtils.getInnerTextList(meta, 'dc:identifier');
      final metaItems = meta
          .findAllElements('meta')
          .map(
            (e) => EpubMetaItem(
              name: e.getAttribute('name') ?? '',
              content: e.getAttribute('content') ?? '',
            ),
          );
      String coverId = '';
      for (var meta in metaItems) {
        if (meta.name == 'cover') {
          coverId = meta.content;
          break;
        }
      }
      // set ctx
      ctx.metadata = .new(
        title: title,
        language: language,
        creators: creator,
        contributor: contributor,
        identifiers: identifier,
        metaItems: metaItems.toList(),
        coverId: coverId,
      );

      // print('title: $title');
      // print('language: $language');
      // print('creator: $creator');
      // print('contributor: $contributor');
      // print('identifier: $identifier');
      // print('metaItems: $metaItems');
      _parseManifestItems(ctx, xml);

      _parseSpineItems(ctx, xml);
      return Ok(true);
    } catch (e) {
      return Err('[EpubContentParser:parse]: $e');
    }
  }

  static void _parseManifestItems(EpubCtx ctx, XmlDocument xml) {
    final manifestItems = xml.findAllElements('manifest');
    if (manifestItems.isNotEmpty) {
      ctx.manifestItems = manifestItems.first
          .findAllElements('item')
          .map(
            (e) => EpubManifestItem(
              id: e.getAttribute('id') ?? '',
              href: e.getAttribute('href') ?? '',
              mediaType: e.getAttribute('media-type') ?? '',
            ),
          )
          .toList();
    }
  }

  static void _parseSpineItems(EpubCtx ctx, XmlDocument xml) {
    final manifestItems = xml.findAllElements('spine');
    if (manifestItems.isNotEmpty) {
      ctx.spineItems = manifestItems.first
          .findAllElements('itemref')
          .map((e) => EpubSpineItem(idref: e.getAttribute('idref') ?? ''))
          .toList();
    }
  }
}
