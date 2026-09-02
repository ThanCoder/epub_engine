// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:epub_engine/src/core/epub_core.dart';
import 'package:epub_engine/src/core/models/epub_metadata.dart';
import 'package:epub_engine/src/core/utils/xml_utils.dart';
import 'package:xml/xml.dart';

void main() async {
  final path = '/home/thancoder/Documents/Docs/သိုးဆောင်း၊ Revenge Story.epub';
  final core = EpubCore();
  final res = core.open(path);
  if (res.isErr) {
    print('error: ${res.unwrapError()}');
    return;
  }
  print(core.ctx);
  print(core.coverPath);
  print('cover data: ${core.coverBytes?.length}');
}

void parse() {
  final text = File('con.xml').readAsStringSync();
  final xml = XmlDocument.parse(text);

  final meta = xml.findAllElements('metadata').first;

  final title = XmlUtils.getInnerTextList(meta, 'dc:title');
  final language = XmlUtils.getInnerText(meta, 'dc:language');
  final creator = XmlUtils.getInnerTextList(meta, 'dc:creator');
  final contributor = XmlUtils.getInnerText(meta, 'dc:contributor');
  final identifier = XmlUtils.getInnerTextList(meta, 'dc:identifier');
  final metaItems = meta
      .findAllElements('meta')
      .map(
        (e) => EpubMetaItem(
          name: e.getAttribute('name') ?? '',
          content: e.getAttribute('content') ?? '',
        ),
      );

  print('title: $title');
  print('language: $language');
  print('creator: $creator');
  print('contributor: $contributor');
  print('identifier: $identifier');
  print('metaItems: $metaItems');

  final manifestItems = xml
      .findAllElements('manifest')
      .first
      .findAllElements('item')
      .map(
        (e) => EpubManifestItem(
          id: e.getAttribute('id') ?? '',
          href: e.getAttribute('href') ?? '',
          mediaType: e.getAttribute('media-type') ?? '',
        ),
      );

  print('manifestItems:');
  for (var item in manifestItems) {
    print(item);
  }

  final spineItems = xml
      .findAllElements('spine')
      .first
      .findAllElements('itemref')
      .map((e) => EpubSpineItem(idref: e.getAttribute('idref') ?? ''));

  print('spineItems:');
  for (var item in spineItems) {
    print(item);
  }
}
