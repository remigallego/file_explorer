import 'package:file_explorer/screens/explorer_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Explorer',
      initialRoute: '/',
      routes: {'/': (context) => ExplorerScreen()},
    );
  }
}
