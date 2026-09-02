import 'package:epub_engine/epub_engine.dart';

void main() async {
  final path =
      '/home/thancoder/Documents/EPUB/ဝိဉာဉ်တေးသွားကဗျာများ၊_ရော်ဝါညိန်း.epub';

  final eng = EpubEngine();

  eng.open(path);

  print('contentFullpath: ${eng.ctx.contentFullpath}');
  print('rootPath: ${eng.ctx.rootPath}');
  print('metadata: ${eng.ctx.metadata}');

  print('coverPath: ${eng.cover.coverPath}');
  print('cover len: ${eng.cover.bytes?.length}');

  for (var item in eng.ctx.spineItems) {
    print('item: $item');
    print('manifestItemsIndex: ${item.manifestItemsIndex}');
    print('content len: ${item.content?.length}');
    // print('contentText: ${item.contentText}');
    // return;
  }

  // genAllCover();
}

// void testCore() {
//   final core = EpubCore();
//   final res = core.open(path);
//   if (res.isErr) {
//     print('error: ${res.unwrapError()}');
//     return;
//   }
//   print(core.ctx);
//   print('title: ${core.ctx.metadata.title}');
//   print('coverPath: ${core.coverPath}');
//   print('cover data: ${core.coverBytes?.length}');

//   print('ncx: ${core.ctx.ncx}');
// }

// void genAllCover() {
//   final dir = Directory('/home/thancoder/Documents/EPUB');
//   final outDir = Directory('${dir.path}/out');
//   if (!outDir.existsSync()) {
//     outDir.createSync(recursive: true);
//   }
//   final files = dir.listSync();
//   int i = 0;
//   for (var f in files) {
//     final name = f.path.split('/').last;
//     if (!name.endsWith('epub')) continue;
//     final out = '${outDir.path}/$name.png';
//     final core = EpubCore();
//     final res = core.open(f.path);
//     if (res.isErr) {
//       print('Error: $name - ${res.unwrapError()}');
//       continue;
//     }
//     i++;
//     print('opend: $i');
//     final saveRes = core.coverSaveToSync(out);
//     if (saveRes.isErr) {
//       print('Error: $name - ${saveRes.unwrapError()}');
//       continue;
//     }
//     print('${saveRes.unwrap() ? 'Saved' : 'Not Save'}: $name - i: $i');
//   }
// }
