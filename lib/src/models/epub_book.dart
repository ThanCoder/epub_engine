// ignore_for_file: public_member_api_docs, sort_constructors_first
class EpubBook {
  final String language;
  final String title;
  final String creator;
  final String date;
  final String identifier;
  final String parentPath;
  const EpubBook({
    required this.language,
    required this.title,
    required this.creator,
    required this.date,
    required this.identifier,
    required this.parentPath,
  });

  @override
  String toString() {
    return 'EpubBook(language: $language, title: $title, creator: $creator, date: $date, identifier: $identifier, parentPath: $parentPath)';
  }
}
