import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NewsReaderApp());
}

class NewsReaderApp extends StatelessWidget {
  const NewsReaderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Reader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
