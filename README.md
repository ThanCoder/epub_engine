# epub_engine

+ [x] [Epub Cover Worker Example](#epub-cover-worker-example)

## Epub Cover Worker Example
```dart
final path = '/home/thancoder/Documents/EPUB/ဝိဉာဉ်တေးသွားကဗျာများ၊_ရော်ဝါညိန်း.epub';

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
```