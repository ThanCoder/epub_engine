import 'package:epub_engine/src/i_epub_engine.dart';

mixin EpubContentHandler on IEpubEngine {
  @override
  String? getContentOpfString() {
    for (var path in core.zipIoHandler.getInnerPathList()) {
      if (path.endsWith('content.opf')) {
        return core.zipIoHandler.getFileContent(path);
      }
    }
    return null;
  }

  @override
  String? getTableOfContentString() {
    for (var path in core.zipIoHandler.getInnerPathList()) {
      if (path.endsWith('toc.ncx')) {
        return core.zipIoHandler.getFileContent(path);
      }
    }
    return null;
  }
}
