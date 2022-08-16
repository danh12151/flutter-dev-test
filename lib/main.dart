import 'package:flutter/material.dart';

import 'Screen/my_home_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Zumstart Screening Test Flutter'),
    );
  }
}

