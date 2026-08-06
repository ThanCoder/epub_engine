// ignore_for_file: public_member_api_docs, sort_constructors_first
class EpubTocItem {
  final String id;
  final int? playOrder;
  final String title;
  final String src;
  final List<EpubTocItem> children;

  const EpubTocItem({
    required this.id,
    required this.playOrder,
    required this.title,
    required this.src,
    this.children = const [],
  });

  @override
  String toString() {
    return 'EpubTocItem(id: $id, playOrder: $playOrder, title: $title, src: $src, children: $children)';
  }
}
