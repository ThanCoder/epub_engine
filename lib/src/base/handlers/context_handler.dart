part of '../epub_engine_base.dart';

mixin ContextHandler on IEpubEngineBase {
  /// ### Book Context
  EpubContext get ctx => _core.ctx;

  /// Epub Book Info
  EpubInfo get info => _core.ctx.info;

  /// Epub Chapter List
  List<EpubChapter> get chapters => _core.getChapters();

  /// Epub Manifest Items
  Map<String, EpubManifestItem> get manifest => _core.ctx.manifest;

  /// Epub Table of Contents
  List<EpubTocItem> get toc => _core.ctx.toc;

  /// Epub Reading Order
  List<EpubSpineItem> get spine => _core.ctx.spine;
}
