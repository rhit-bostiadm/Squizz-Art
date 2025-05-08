import 'package:flutter/material.dart';
import 'package:squizz_art/draw_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squizz Art',
      theme: ThemeData.light(),
      home: const DrawPage(),
    );
  }
}