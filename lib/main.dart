import 'package:flutter/material.dart';
import 'package:note_keeper/screens/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blue[200],
        backgroundColor: Colors.blue[300],
        cardColor: Colors.blue[400],
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
