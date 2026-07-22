# epub_engine

+ [x] `EpubThumbnailWorker`

## EpubThumbnailWorker Example
```dart
for (var file in dir.listSync(followLinks: false)) {
    if (!file.path.endsWith('.epub')) continue;

    final name = file.path.split('/').last.split('.').first;
    final succ = await EpubThumbnailWorker.getInstance.generate(
        file.path,
        '${outDir.path}/$name.png',
    );
    print('generated: $succ - $name');
}
```