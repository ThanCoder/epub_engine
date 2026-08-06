import 'package:epub_engine/src/core/i_epub_core_engine.dart';
import 'package:epub_engine/src/models/epub_manifest_item.dart';
import 'package:epub_engine/src/models/epub_spine_item.dart';
import 'package:xml/xml.dart';

mixin SpineHandler on IEpubCoreEngine {
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

}
