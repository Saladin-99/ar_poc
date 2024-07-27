import 'package:flutter/material.dart';
import 'screens/ar_screen.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Dot Placer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ARScreen(),
    );
  }
}
