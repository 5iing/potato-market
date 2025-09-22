import 'package:flutter/material.dart';
import 'components/tab_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potato Market',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: 'SpoqaHanSansNeo',
        useMaterial3: true,
      ),
      home: const TabView(),
    );
  }
}
