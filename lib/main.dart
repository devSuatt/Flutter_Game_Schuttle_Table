import 'package:flutter/material.dart';
import 'ui/game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Schuttle Table",
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.lightBlue[200],
      ),
      home: Game(),
      
    );
  }
}
