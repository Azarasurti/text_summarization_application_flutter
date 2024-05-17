import 'package:flutter/material.dart';
import 'package:text_summarization_application/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
