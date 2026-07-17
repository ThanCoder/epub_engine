// ignore_for_file: public_member_api_docs, sort_constructors_first
class BookChapterItem {
  final String path;
  final String name;
  const BookChapterItem({required this.path, required this.name});

  @override
  String toString() => 'BookChapterItem(path: $path, name: $name)';
}
