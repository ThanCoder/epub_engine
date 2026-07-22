import 'package:epub_engine/src/core/core_engine.dart';

abstract class IEpubEngine {
  void open(String path);
  void dispose();

  String? getContentOpfString();
  String? getTableOfContentString();

  CoreEngine get core;
}
