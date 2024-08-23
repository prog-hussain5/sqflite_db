import 'package:db_sqflite/basic_test/home_page.dart';
import 'package:db_sqflite/pro_test/home2_page2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesApp2(),
    );
  }
}