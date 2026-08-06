// ignore_for_file: public_member_api_docs, sort_constructors_first
class EpubManifestItem {
  final String id;
  final String href;
  final String mediaType;

  const EpubManifestItem({
    required this.id,
    required this.href,
    required this.mediaType,
  });

  @override
  String toString() => 'EpubManifestItem(id: $id, href: $href, mediaType: $mediaType)';
}
