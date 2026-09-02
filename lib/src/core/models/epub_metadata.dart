// ignore_for_file: public_member_api_docs, sort_constructors_first
class EpubMetadata {
  const EpubMetadata({
    this.title = '',
    this.language = '',
    this.contributor = '',
    this.creators = const [],
    this.identifiers = const [],
    this.metaItems = const [],
    this.coverId = '',
  });

  final String title;
  final String language;
  final String contributor;
  final List<String> creators;
  final List<String> identifiers;
  final String coverId;
  final List<EpubMetaItem> metaItems;

  @override
  String toString() {
    return 'EpubMetadata(title: $title, language: $language, contributor: $contributor, creators: $creators, identifiers: $identifiers, coverId: $coverId, metaItems: $metaItems)';
  }
}

class EpubMetaItem {
  final String name;
  final String content;
  const EpubMetaItem({required this.name, required this.content});

  @override
  String toString() => 'EpubMetaItem(name: $name, content: $content)';
}

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
  String toString() =>
      'EpubManifestItem(id: $id, href: $href, mediaType: $mediaType)';
}

class EpubSpineItem {
  final String idref;
  const EpubSpineItem({required this.idref});

  @override
  String toString() => 'EpubSpineItem(idref: $idref)';
}
