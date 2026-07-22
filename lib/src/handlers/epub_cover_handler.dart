import 'dart:io';
import 'dart:typed_data';

import 'package:epub_engine/src/i_epub_engine.dart';

mixin EpubCoverHandler on IEpubEngine {
  /// ### Book Cover Write Data
  ///
  /// Supported -> `v2`,`v3`
  ///
  ///
  bool writeAsCoverFile(String outPath) {
    final bytes = getCoverData();
    if (bytes != null) {
      final file = File(outPath);
      file.writeAsBytesSync(bytes);
      return true;
    }
    return false;
  }

  /// ### Book Cover Data
  ///
  /// Supported -> `v2`,`v3`
  ///
  Uint8List? getCoverData() {
    String innerPath = '';
    for (var path in core.zipIoHandler.getInnerPathList()) {
      if (path.endsWith('content.opf')) {
        innerPath = path;
        break;
      }
    }

    if (innerPath.isEmpty) return null;

    final content = core.zipIoHandler.getFileContent(innerPath);
    if (content == null) return null;

    String? targetHref;
    String? coverIdFromMeta;

    // --- အဆင့် ၁။ Namespace ပါ/မပါ Element များကို စုဆောင်းခြင်း ---
    var items = core.xmlParser.findAllElements(content, 'item');
    if (items.isEmpty) {
      items = core.xmlParser.findAllElements(content, 'opf:item');
    }

    var metas = core.xmlParser.findAllElements(content, 'meta');
    if (metas.isEmpty) {
      metas = core.xmlParser.findAllElements(content, 'opf:meta');
    }

    // နည်းလမ်း (က) EPUB 3 Standard (properties="cover-image")
    for (var ele in items) {
      final properties = ele.getAttribute('properties');
      if (properties != null && properties.contains('cover-image')) {
        targetHref = ele.getAttribute('href');
        break;
      }
    }

    // နည်းလမ်း (ခ) EPUB 2 Standard (<meta name="cover" content="id_or_filename" />)
    if (targetHref == null) {
      for (var ele in metas) {
        final attrName = ele.getAttribute('name');
        if (attrName == 'cover') {
          coverIdFromMeta = ele.getAttribute('content');
          if (coverIdFromMeta != null && coverIdFromMeta.isNotEmpty) {
            break;
          }
        }
      }

      if (coverIdFromMeta != null) {
        for (var ele in items) {
          final id = ele.getAttribute('id');
          final href = ele.getAttribute('href');
          final mediaType = ele.getAttribute('media-type') ?? '';

          // XHTML/HTML ဖိုင် မဟုတ်ဘဲ Image ဖိုင်ဖြစ်မှသာ ယူမည်
          final isImage = mediaType.startsWith('image/');

          // Standard ID match
          if (id == coverIdFromMeta && isImage) {
            targetHref = href;
            break;
          }

          // Non-standard filename match
          if (href != null && href.endsWith(coverIdFromMeta) && isImage) {
            targetHref = href;
            break;
          }
        }
      }
    }

    // နည်းလမ်း (ဂ) Fallback - Standard မလိုက်နာပါက ID သို့မဟုတ် HREF ထဲတွင် cover ပါသော Image ကို ရှာမည်
    if (targetHref == null) {
      for (var ele in items) {
        final id = (ele.getAttribute('id') ?? '').toLowerCase();
        final href = (ele.getAttribute('href') ?? '').toLowerCase();
        final mediaType = (ele.getAttribute('media-type') ?? '').toLowerCase();

        if (mediaType.startsWith('image/') &&
            (id.contains('cover') || href.contains('cover'))) {
          targetHref = ele.getAttribute('href');
          break;
        }
      }
    }

    if (targetHref == null) return null;

    // --- အဆင့် ၂။ Path Normalization & Full ZIP Path Building ---

    // URL Encode ဖြုတ်ခြင်း (ဥပမာ- %20 -> space) နှင့် Windows Separator ပြင်ခြင်း
    targetHref = Uri.decodeFull(targetHref).replaceAll('\\', '/');

    final lastSlashIndex = innerPath.lastIndexOf('/');
    final opfParentDir = (lastSlashIndex != -1)
        ? innerPath.substring(0, lastSlashIndex + 1)
        : '';

    final fullImagePath = '$opfParentDir$targetHref';

    return core.zipIoHandler.getFileBytes(fullImagePath);
  }
}
