import 'package:flutter/material.dart';
import 'package:flutter_web/screens/home_page.dart';

import 'screens/second_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Intro',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => HomePage(),
          '/secondpage': (context) => SecondPage(),
        });
  }
}
