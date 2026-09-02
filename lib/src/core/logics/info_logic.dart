part of '../epub_core.dart';

mixin InfoLogic on IEpubCore {
  @override
  Result<bool, String> loadInfo() {
    final pcRes = _parseContainer();
    if (pcRes.isErr) {
      return pcRes;
    }
    final pcConRes = _parseContent();
    if (pcConRes.isErr) {
      return pcConRes;
    }
    return Ok(true);
  }

  Result<bool, String> _parseContainer() {
    try {
      final name = reader.names.firstWhere((e) => e.endsWith('container.xml'));
      final content = reader.getContentText(name);
      if (content == null) {
        return Err('[InfoLogic:_parseContainer]: content == null');
      }
      ctx.contentFullpath = XmlUtils.getContentFullpath(content);
      if (ctx.contentFullpath.isNotEmpty) {
        final parts = ctx.contentFullpath.split('/');
        parts.removeLast();
        ctx.rootPath = parts.join('/');
      }
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  Result<bool, String> _parseContent() {
    try {
      final content = reader.getContentText(ctx.contentFullpath);
      if (content == null) {
        return Err('[InfoLogic:_parseContent]: content == null');
      }
      final res = EpubContentParser.parse(ctx, content);
      if (res.isErr) {
        return res;
      }
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
