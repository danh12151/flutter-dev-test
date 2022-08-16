import 'package:flutter/material.dart';
import 'package:screening_test/Screen/custom_scroll_view.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DemoWithCustomScrollView()
                  //builder: (context) => UberEatsDemo()
              ),
            );
          },
          child: Text(
              "Click here for demo"
          ),
        ),
      )
    );
  }
}