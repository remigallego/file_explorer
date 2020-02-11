import 'package:file_explorer/providers/directory_provider.dart';
import 'package:file_explorer/screens/directory_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => DirectoryProvider())],
        child: MaterialApp(
          title: 'File Explorer',
          initialRoute: '/',
          routes: {'/': (context) => DirectoryScreen()},
        ));
  }
}
