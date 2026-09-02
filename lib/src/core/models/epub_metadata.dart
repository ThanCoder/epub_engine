class EpubMetadata {
  const EpubMetadata({
    this.title = '',
    this.language = const [],
    this.contributor = const [],
    this.creators = const [],
    this.identifiers = const [],
    this.metaItems = const [],
    this.coverId = '',
  });

  final String title;
  final List<String> language;
  final List<String> contributor;
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

