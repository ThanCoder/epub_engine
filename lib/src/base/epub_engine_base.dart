import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:epub_engine/epub_engine.dart';
import 'package:epub_engine/src/core/core_engine.dart';
import 'package:epub_engine/src/core/context/epub_context.dart';
import 'package:epub_engine/src/core/zip_io_handler.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:path/path.dart';

part 'handlers/context_handler.dart';
part 'handlers/async_handler.dart';
part 'handlers/sync_handler.dart';
part 'handlers/content_path_helper.dart';
part 'handlers/zip_io_helper.dart';

abstract class IEpubEngineBase {
  CoreEngine get _core;
}

class EpubEngine extends IEpubEngineBase
    with
        ContextHandler,
        SyncHandler,
        AsyncHandler,
        ContentPathHelper,
        ZipIoHelper {
  @override
  final _core = CoreEngine();

  /// Close Book
  void dispose() {
    _core.dispose();
  }
}
