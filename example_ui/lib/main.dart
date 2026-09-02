import 'package:example_ui/epub_reader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp(), theme: .dark()));
}

class MyApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpubReader(
                path: '/home/thancoder/Documents/EPUB/ကက်စပါဇော်၊_ပျော်ရွှင်ဖို့လိုအပ်တဲ့သတ္တိ.epub',
              ),
            ),
          );
        },
      ),
    );
  }
}
