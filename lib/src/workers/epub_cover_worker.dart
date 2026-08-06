import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:epub_engine/epub_engine.dart';

enum EpubCoverWorkerCommand {
  stop,
  generate;

  static EpubCoverWorkerCommand fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => stop);
  }
}

class EpubCoverWorker {
  static EpubCoverWorker getInstance = EpubCoverWorker._();

  EpubCoverWorker._();

  factory EpubCoverWorker() => getInstance;

  final autoCloseDuration = const Duration(seconds: 5);

  Isolate? _isolate;
  SendPort? _workerSendPort;
  Completer<void>? _completer;
  Timer? _autoCloseTimer;

  /// Thumbnail Generated
  Future<bool> generate(
    String srcPath,
    String outPath, {
    bool isOverride = false,
  }) async {
    final f = File(outPath);
    if (!isOverride && f.existsSync()) {
      return false;
    }

    _autoCloseTimer?.cancel();

    await _isoalteReady();

    final receive = ReceivePort();

    try {
      _workerSendPort!.send({
        'path': srcPath,
        'out_path': outPath,
        'command': EpubCoverWorkerCommand.generate.name,
        'reply': receive.sendPort,
      });

      return await receive.first as bool;
    } catch (e) {
      print('[EpubCoverWorker:generate]: `$e`');
      return false;
    } finally {
      receive.close();
      _startAutoCloseTimer();
    }
  }

  Future<void> _isoalteReady() async {
    if (_workerSendPort != null) {
      return;
    }

    if (_completer != null) {
      return _completer!.future;
    }

    _completer = Completer<void>();

    try {
      await _startIsolate();

      _completer!.complete();
    } catch (e, st) {
      _workerSendPort = null;
      _isolate = null;

      _completer!.completeError(e, st);

      // Allow next call to retry initialization.
      _completer = null;

      rethrow;
    }
  }

  Future<void> _startIsolate() async {
    final receivePort = ReceivePort();

    try {
      _isolate = await Isolate.spawn(_backgroundWorker, receivePort.sendPort);

      _workerSendPort = await receivePort.first as SendPort;

      print('[EpubCoverWorker:_startIsolate]: created');
    } finally {
      receivePort.close();
    }
  }

  void _startAutoCloseTimer() {
    _autoCloseTimer?.cancel();

    _autoCloseTimer = Timer(autoCloseDuration, _closeIsolate);
  }

  void _closeIsolate() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;

    _isolate?.kill(priority: Isolate.immediate);

    _isolate = null;
    _workerSendPort = null;
    _completer = null;
    print('[EpubCoverWorker:_startIsolate]: destroy');
  }
}

void _backgroundWorker(SendPort mainSendPort) {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);

  bool generate(String path, String outpath) {
    try {
      // print('worker: $path');
      final epub = EpubEngine();
      epub.openSync(path);
      
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
      final command = EpubCoverWorkerCommand.fromValue(message['command']);
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
