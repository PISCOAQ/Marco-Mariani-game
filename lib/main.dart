import 'package:flutter/material.dart';
import 'package:gioco_demo/screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'game_demo',
      home: const HomeScreen(),
    );
  }
}
