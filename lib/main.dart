import 'package:flutter/material.dart';
import 'package:weatherapp/screens/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 0, 93, 192)),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Home(),
          ),
        ),
      ),
    );
  }
}
