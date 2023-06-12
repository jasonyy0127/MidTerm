import 'package:flutter/material.dart';

import 'HomePage/startpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BarterIt App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.amber,
      ),
      home: const StartPage(),
    );
  }
}
