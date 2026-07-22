class EpubNav {
  final String title;
  final List<EpubNavItem> items;
  const EpubNav({required this.title, required this.items});

  @override
  String toString() => 'EpubNav(title: $title, items: $items)';
}

class EpubNavItem {
  final String point;
  final String label;
  final String path;
  const EpubNavItem({
    required this.point,
    required this.label,
    required this.path,
  });

  @override
  String toString() => 'EpubNavItem(point: $point, label: $label, path: $path)';
}