// ignore_for_file: public_member_api_docs, sort_constructors_first
class BookChapterItem {
  final String id;
  final String href;
  const BookChapterItem({required this.id, required this.href});

  @override
  String toString() => 'BookChapterItem(id: $id, href: $href)';
}
