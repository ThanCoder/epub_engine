// import 'dart:isolate';

// import 'package:epub_engine/src/epub_engine_base.dart';

// class EpubBookWorker {
//   static EpubBookWorker instance = EpubBookWorker._();
//   EpubBookWorker._();
//   factory EpubBookWorker() => instance;

//   bool _opened = false;
//   bool get opened => _opened;
//   Isolate? _isolate;
//   SendPort? _workerSendPort;

//   Future<void> open(String epubPath) async {
//     if (_opened) return;
//     final rp = ReceivePort();
//     _isolate = await Isolate.spawn<(SendPort, String)>(_bookWorker, (
//       rp.sendPort,
//       epubPath,
//     ));
//     _workerSendPort = rp.first as SendPort;
//     rp.close();
//   }

//   Future<void> dipose() async {
//     _isolate?.kill(priority: Isolate.immediate);
//     _isolate = null;
//     _workerSendPort = null;
//     _opened = false;
//   }
// }

// enum EpubBookWorkerCommand {
//   fetchChapterList,
//   fetchChapterContent,
//   unknown;

//   static EpubBookWorkerCommand fromValue(String val) {
//     return values.firstWhere((e) => e.name == val, orElse: () => unknown);
//   }
// }

// void _bookWorker((SendPort, String) args) {
//   final (mainSendport, path) = args;
//   final rp = ReceivePort();
//   mainSendport.send(rp.sendPort);

//   final en = EpubEngine();
//   en.open(path);

//   rp.listen((msg) {
//     if (msg is Map) {
//       final reply = msg['reply'] as SendPort;
//       final command = EpubBookWorkerCommand.fromValue(msg['command']);
//       if (command == .fetchChapterList) {
//         final chMapList = en.getChapters.map((e) => e.toMap()).toList();
//         reply.send(chMapList);
//       }
//     }
//   });
// }
