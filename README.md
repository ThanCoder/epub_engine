# epub_engine

+ [x] [Epub Cover Worker Example](#epub-cover-worker-example)

## Epub Cover Worker Example
```dart
  final dir = Directory('/home/thancoder/Documents/Docs');
  final outDir = Directory('${dir.path}/thumbs');
  if (!outDir.existsSync()) {
    await outDir.create();
  }

  for (var file in dir.listSync(followLinks: false)) {
    if (!file.path.endsWith('.epub')) continue;

    final name = file.path.split('/').last.split('.').first;
    final nameOnly = name.split('.').first;
    final outpath = '${outDir.path}/$name.png';
    final succ = await EpubCoverWorker.getInstance.generate(file.path, outpath);
    print('generated: $succ - $name');
    print('outpath: $outpath');
  }
```