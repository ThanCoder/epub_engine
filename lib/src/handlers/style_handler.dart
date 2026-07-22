// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epub_engine/src/i_epub_engine.dart';

class EpubStyle {
  final String name;
  final String path;
  const EpubStyle({required this.name, required this.path});

  @override
  String toString() => 'EpubStyle(name: $name)';
}

mixin StyleHandler on IEpubEngine {
  /// Epub Fonts
  List<EpubStyle> getStyles() {
    List<EpubStyle> list = [];

    for (var path in core.zipIoHandler.getInnerPathList()) {
      final name = path.split('/').last;
      if (!name.endsWith('.ttf')) continue;
      list.add(EpubStyle(name: name, path: path));
    }

    return list;
  }

  /// Get Content
  String getStyleContent(EpubStyle style) {
    return core.zipIoHandler.getFileContent(style.path)!;
  }

  /// ### save font file
  bool writeAsStyleFile(String outpath, EpubStyle style) {
    return core.zipIoHandler.writeAsFile(style.path, outpath);
  }
}
