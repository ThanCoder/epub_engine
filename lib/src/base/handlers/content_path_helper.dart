part of '../epub_engine_base.dart';

mixin ContentPathHelper on IEpubEngineBase {
  /// `%20` -> `' '`
  String normalizedPath(String path) {
    return Uri.decodeComponent(path).replaceAll('../', '');
  }

  /// content path -> zip fullpath
  String getZipFullpath(String path) {
    path = normalizedPath(path);
    for (var zp in _core.ctx.zipPathList) {
      if (zp.endsWith(path)) {
        return zp;
      }
    }
    // if (_core.ctx.opfParentPath.isNotEmpty) {
    //   return '${_core.ctx.opfParentPath}/$path';
    // }
    return path;
  }

  String resolveHtmlContent(
    String html, {
    Map<String, Set<String>> tagAttributes = const {
      'img': {'src'},
      'image': {'href'},
      'link': {'href'},
    },
    String Function(String tag, String attribute, String content)? onResolve,
  }) {
    if (onResolve == null) {
      return html;
    }

    final document = html_parser.parse(html);

    for (final entry in tagAttributes.entries) {
      final tag = entry.key;
      final attributes = entry.value;

      for (final element in document.querySelectorAll(tag)) {
        for (final attribute in attributes) {
          Object? actualKey;

          for (final attrEntry in element.attributes.entries) {
            final key = attrEntry.key.toString();
            // print('key: $key');

            // xlink:href -> href
            // href      -> href
            if (key == attribute || key.endsWith(attribute)) {
              actualKey = attrEntry.key;
              break;
            }
          }

          if (actualKey == null) {
            continue;
          }

          final content = element.attributes[actualKey];

          if (content == null || content.isEmpty) {
            continue;
          }
          element.attributes.remove(actualKey);
          element.attributes['src'] = onResolve(tag, attribute, content);
        }
      }
    }

    return document.outerHtml
        .replaceAll('<image', '<img')
        .replaceAll('</image>', '<img>');
  }

  String resolveCssContent(
    String css, {
    required String cssZipPath,
    required String cachePath,
  }) {
    final regex = RegExp(
      r'''url\(\s*(['"]?)(.*?)\1\s*\)''',
      caseSensitive: false,
    );

    return css.replaceAllMapped(regex, (match) {
      final resource = match.group(2)!;

      if (resource.startsWith('data:') ||
          resource.startsWith('http://') ||
          resource.startsWith('https://')) {
        return match.group(0)!;
      }

      final cssDir = dirname(cssZipPath);

      final resourceZipPath = normalize(join(cssDir, resource));

      final cacheFullPath = join(cachePath, resourceZipPath);

      return 'url(${Uri.file(cacheFullPath).toString()})';
    });
  }
}
