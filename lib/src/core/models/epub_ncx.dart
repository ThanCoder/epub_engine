// ignore_for_file: public_member_api_docs, sort_constructors_first
class EpubNcx {
  final String? uuid;
  final String? title;
  final String? author;
  final List<EpubNavPoint> navPoints;

  const EpubNcx({
    this.uuid,
    this.title,
    this.author,
    this.navPoints = const [],
  });

  @override
  String toString() {
    return 'EpubNcx(uuid: $uuid, title: $title, author: $author, navPoints: $navPoints)';
  }
}

class EpubNavPoint {
  final String id;
  final int? playOrder;
  final String? className;
  final String label;
  final String src;
  final List<EpubNavPoint> children;

  const EpubNavPoint({
    required this.id,
    this.playOrder,
    this.className,
    required this.label,
    required this.src,
    this.children = const [],
  });

  @override
  String toString() {
    return 'EpubNavPoint(id: $id, playOrder: $playOrder, className: $className, label: $label, src: $src, children: $children)';
  }
}
