import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appTheme = ThemeData(
      primaryColor: Color(0xff6DD86),
      accentColor: Color(0xff405E79),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
    return MaterialApp(title: 'Flutter Demo', theme: appTheme);
  }
}
