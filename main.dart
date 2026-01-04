import 'package:flutter/material.dart';
import 'welcomepage.dart';

void main() => runApp(const WazeefatiApp());

class WazeefatiApp extends StatelessWidget {
  const WazeefatiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wazeefati',
      home: WelcomePage(),
    );
  }
}
