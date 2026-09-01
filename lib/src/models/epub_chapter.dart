

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'href': href,
      'mediaType': mediaType,
      'index': index,
      'linear': linear,
    };
  }

  factory EpubChapter.fromMap(Map<String, dynamic> map) {
    return EpubChapter(
      id: map['id'] as String,
      href: map['href'] as String,
      mediaType: map['mediaType'] as String,
      index: map['index'] as int,
      linear: map['linear'] as bool,
    );
  }
}
