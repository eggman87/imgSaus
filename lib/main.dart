import 'package:flutter/material.dart';
import 'package:imgsrc/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'imgSaus',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {'/': (context) => MyHomePage(title: 'imgSaus',)},
    );
  }
}


