import 'dart:async';
import 'dart:isolate';

import 'package:epub_engine/epub_engine.dart';

enum EpubThumbnailWorkerCommand {
  stop,
  generate;

  static EpubThumbnailWorkerCommand fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => stop);
  }
}

class EpubThumbnailWorker {
  static EpubThumbnailWorker getInstance = EpubThumbnailWorker._();
  EpubThumbnailWorker._();
  factory EpubThumbnailWorker() => getInstance;

  /// Thumbnail Generated
  Future<bool> generate(String srcPath, String outPath) async {
    _autoCloseTimer?.cancel();
    await _init();
    bool generated = false;
    final receive = ReceivePort();

    try {
      _backgroundSendPort!.send({
        'path': srcPath,
        'out_path': outPath,
        'command': EpubThumbnailWorkerCommand.generate.name,
        'reply': receive.sendPort,
      });
      generated = await receive.first as bool;
    } catch (e) {
      print('[EpubThumbnailWorker:generate]: `$e`');
    } finally {
      receive.close;
    }
    _startAutoCloseTimer();

    return generated;
  }

  Isolate? _isolate;
  SendPort? _backgroundSendPort;
  Future<void>? _gateKeeper;
  Timer? _autoCloseTimer;

  Future<void> _init() async {
    _gateKeeper ??= _startIsolate();
    return _gateKeeper!;
  }

  Future<void> _startIsolate() async {
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_backgroundWorker, receivePort.sendPort);
    _backgroundSendPort = await receivePort.first as SendPort;
    receivePort.close();
    print('[EpubThumbnailWorker:_startIsolate]: created');
  }

  void _startAutoCloseTimer() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = Timer(Duration(seconds: 5), () {
      _closeIsolate();
    });
  }

  void _closeIsolate() async {
    _gateKeeper = null;

    final rec = ReceivePort();
    _backgroundSendPort?.send({
      'command': EpubThumbnailWorkerCommand.stop.name,
      'reply': rec.sendPort,
    });
    await rec.first;
    rec.close();

    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _backgroundSendPort = null;
  }
}

void _backgroundWorker(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);

  bool generate(String path, String outpath) {
    try {
      final epub = EpubEngine();
      epub.open(path);
      final res = epub.saveAsCoverSync(outpath);
      epub.dispose();
      return res;
    } catch (e) {
      print('[_backgroundWorker]: `$e`');
      return false;
    }
  }

  receivePort.listen((message) {
    if (message is Map) {
      final command = EpubThumbnailWorkerCommand.fromValue(message['command']);
      final reply = message['reply'] as SendPort;
      if (command == .stop) {
        receivePort.close();
        reply.send(true);
        print('[_backgroundWorker]: closed');
      } else if (command == .generate) {
        final path = message['path'] as String;
        final outpath = message['out_path'] as String;
        final res = generate(path, outpath);
        reply.send(res);
        // print('[_backgroundWorker:generated]: `$outpath`');
      }
    }
  });
}
