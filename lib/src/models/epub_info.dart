// ignore_for_file: public_member_api_docs, sort_constructors_first
///
/// ```xml
///    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
///     <dc:language>my</dc:language>
///     <dc:title>ဝါးမျိုခြင်းစာအုပ်</dc:title>
///     <dc:creator opf:role="aut">PSM</dc:creator>
///     <meta name="Sigil version" content="2.1.0"/>
///     <dc:date opf:event="modification" xmlns:opf="http://www.idpf.org/2007/opf">2024-05-04</dc:date>
///     <dc:identifier opf:scheme="UUID" id="BookId">urn:uuid:8906e440-08a1-4d25-8240-a02be5200ea2</dc:identifier>
///     <meta name="cover" content="a-1.jpg"/>
///   </metadata>
///
/// ```
class EpubInfo {
  final String? language;
  final String? title;
  final String? creator;
  final String? creatorRole;
  final String? identifier;
  final String? identifierScheme;
  final String? date;
  final String? dateEvent;
  final String? cover;

  const EpubInfo({
    this.language,
    this.title,
    this.creator,
    this.creatorRole,
    this.identifier,
    this.identifierScheme,
    this.date,
    this.dateEvent,
    this.cover,
  });

  @override
  String toString() {
    return 'EpubInfo(language: $language, title: $title, creator: $creator, creatorRole: $creatorRole, identifier: $identifier, identifierScheme: $identifierScheme, date: $date, dateEvent: $dateEvent, cover: $cover)';
  }
}
