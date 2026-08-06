// ignore_for_file: public_member_api_docs, sort_constructors_first
class EpubChapter {
  final String id;
  final String href;
  final String mediaType;
  final int index;
  final bool linear;

  const EpubChapter({
    required this.id,
    required this.href,
    required this.mediaType,
    required this.index,
    this.linear = true,
  });

  @override
  String toString() {
    return 'EpubChapter(id: $id, href: $href, mediaType: $mediaType, index: $index, linear: $linear)';
  }
}
