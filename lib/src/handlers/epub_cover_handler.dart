import 'dart:io';
import 'dart:typed_data';

import 'package:epub_engine/src/i_epub_engine.dart';

mixin EpubCoverHandler on IEpubEngine {
  /// ### Book Cover Write Data
  ///
  /// Supported -> `v2`,`v3`
  ///
  ///
  bool saveAsCoverPath(String outPath) {
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
    final content = core.zipIoHandler.getFileContent('OEBPS/content.opf');
    if (content == null) return null;

    String? targetHref;
    String? coverIdFromMeta;

    // --- အဆင့် ၁။ XML ရဲ့ item tags တွေနဲ့ meta tags တွေကို အရင် loop ပတ်ပြီး data စုမယ် ---

    // V3 အတွက် item tags တွေကို စစ်မယ်
    final items = core.xmlParser.findAllElements(content, 'item');
    // V2 အတွက် meta tags တွေကို စစ်မယ်
    final metas = core.xmlParser.findAllElements(content, 'meta');

    // နည်းလမ်း (က) EPUB 3 Standard အရင်ရှာမယ်
    for (var ele in items) {
      final properties = ele.getAttribute('properties');
      if (properties != null && properties == 'cover-image') {
        targetHref = ele.getAttribute('href');
        break; // ရှာတွေ့ရင် loop ထဲက တန်းထွက်မယ်
      }
    }

    // နည်းလမ်း (ခ) EPUB 3 မတွေ့ရင် EPUB 2 Standard ကို ရှာမယ်
    if (targetHref == null) {
      for (var ele in metas) {
        final attrName = ele.getAttribute('name');
        if (attrName != null && attrName == 'cover') {
          coverIdFromMeta = ele.getAttribute(
            'content',
          ); // ဒါက ID ဖြစ်နိုင်သလို ဖိုင်နာမည်လည်း ဖြစ်နိုင်တယ်
          break;
        }
      }

      if (coverIdFromMeta != null) {
        // ရလာတဲ့ ID နဲ့ ကိုက်ညီတဲ့ item ရဲ့ href ကို manifest ထဲမှာ ပြန်ရှာမယ်
        for (var ele in items) {
          final id = ele.getAttribute('id');
          final href = ele.getAttribute('href');

          // standard အတိုင်း ID နဲ့ တိုက်စစ်တာ
          if (id != null && id == coverIdFromMeta) {
            targetHref = href;
            break;
          }

          // အခုနက မိတ်ဆွေပြတဲ့ စာအုပ်လို Non-standard (content ထဲ ဖိုင်နာမည် တန်းထည့်ထားရင်) စစ်ဖို့
          if (href != null && href.endsWith(coverIdFromMeta)) {
            targetHref = href;
            break;
          }
        }
      }
    }

    // --- အဆင့် ၂။ ရလာတဲ့ href ကို တကယ့် ZIP Path အမှန်အဖြစ် ပြောင်းလဲခြင်း ---
    if (targetHref == null) return null;

    // ပုံသေ OEBPS/Images လို့ မပေးဘဲ opf ဖိုင်ရဲ့ တကယ့် အရှေ့က parent path အတိုင်း တွက်ချက်တာက ပိုစိတ်ချရပါတယ်
    // ဥပမာ - 'OEBPS/content.opf' -> 'OEBPS'
    final opfParent = 'OEBPS';

    // လမ်းကြောင်းအပြည့်အစုံ ဆောက်မယ်
    final fullImagePath = '$opfParent/$targetHref';

    // စာအုပ်အချို့မှာ path စောင်းတာတွေ (/ သို့မဟုတ် \) ရှင်းအောင် လိုအပ်ရင် normalize လုပ်နိုင်ပါတယ်
    return core.zipIoHandler.getFileBytes(fullImagePath);
  }
}
