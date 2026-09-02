import 'package:epub_engine/epub_engine.dart';
import 'package:example_ui/content_page.dart';
import 'package:flutter/material.dart';

class EpubReader extends StatefulWidget {
  const new({super.key, required this.path});
  final String path;

  @override
  State<EpubReader> createState() => _EpubReaderState();
}

class _EpubReaderState extends State<EpubReader> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    eng.close();
    super.dispose();
  }

  final eng = EpubEngine();

  void init() {
    eng.open(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: eng.state.spineItems.length,
        itemBuilder: (context, index) => _listItem(eng.state.spineItems[index]),
      ),
    );
  }

  String? clickedIdref;

  Widget _listItem(EpubSpineItem item) {
    return ListTile(
      textColor: clickedIdref == item.idref ? Colors.blue : null,
      title: Text(item.idref),
      onTap: () async {
        clickedIdref = item.idref;
        final content = item.contentText!;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentPage(content: content),
          ),
        );
        setState(() {});
      },
    );
  }
}
