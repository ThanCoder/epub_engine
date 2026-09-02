import 'package:epub_engine/src/core/epub_core.dart';
import 'package:epub_engine/src/core/models/epub_manifest_item.dart';
import 'package:epub_engine/src/core/result_t.dart';
import 'package:epub_engine/src/engine/engine_cover.dart';
import 'package:epub_engine/src/engine/engine_ctx.dart';

class EpubEngine {
  final _core = EpubCore();

  late final EngineCtx state = EngineCtx(_core.ctx);
  late final EngineCover cover = EngineCover(_core);

  Result<bool, String> open(String path) {
    return _core.open(path);
  }

  String getFullPathByHref(String href) => _core.getFullPathByHref(href);

  String getFullPathByItem(EpubManifestItem item) =>
      _core.getFullPathByItem(item);

  void close() {
    _core.close();
  }
}
