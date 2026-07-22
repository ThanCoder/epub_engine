// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epub_engine/src/i_epub_engine.dart';

class EpubFont {
  final String name;
  final String path;
  const EpubFont({required this.name, required this.path});

  EpubFont copyWith({String? name, String? path}) {
    return EpubFont(name: name ?? this.name, path: path ?? this.path);
  }

  @override
  String toString() => 'EpubFont(name: $name)';
}

mixin FontHandler on IEpubEngine {
  /// Epub Fonts
  List<EpubFont> getFonts() {
    List<EpubFont> list = [];

    for (var path in core.zipIoHandler.getInnerPathList()) {
      final name = path.split('/').last;
      if (!name.endsWith('.ttf')) continue;
      list.add(EpubFont(name: name, path: path));
    }

    return list;
  }

  /// Get Content
  String getFontContent(EpubFont font) {
    return core.zipIoHandler.getFileContent(font.path)!;
  }

  /// ### save font file
  bool writeAsFontFile(String outpath, EpubFont font) {
    return core.zipIoHandler.writeAsFile(font.path, outpath);
  }
}
