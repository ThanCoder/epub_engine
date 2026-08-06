import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/models/epub_manifest_item.dart';
import 'package:xml/xml.dart';

mixin ManifestHandler on IEpubCoreEngine {
  void loadManifest(
    String opfContent,
    Map<String, EpubManifestItem> manifest,
  ) {
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

      if (id == null || href == null || mediaType == null) {
        continue;
      }

      manifest[id] = EpubManifestItem(id: id, href: href, mediaType: mediaType);
    }
  }
}
