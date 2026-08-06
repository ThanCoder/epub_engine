// ignore_for_file: public_member_api_docs, sort_constructors_first
class EpubSpineItem {
  /// spine itemref ရဲ့ idref
  final String idref;

  /// manifest item ရဲ့ id
  final String id;

  /// manifest item ရဲ့ href
  /// ဥပမာ: index_split_000.html
  final String href;

  /// media-type
  /// ဥပမာ: application/xhtml+xml
  final String mediaType;

  /// reading order
  final int index;

  /// spine itemref ရဲ့ linear attribute
  final bool linear;

  /// EPUB ထဲက actual path
  /// ဥပမာ: OEBPS/index_split_000.html
  final String path;

  const EpubSpineItem({
    required this.idref,
    required this.id,
    required this.href,
    required this.mediaType,
    required this.index,
    required this.linear,
    required this.path,
  });

  @override
  String toString() {
    return 'EpubSpineItem(idref: $idref, id: $id, href: $href, mediaType: $mediaType, index: $index, linear: $linear, path: $path)';
  }
}
