import 'package:flutter/material.dart';
import 'calc.dart';

void main() {
  runApp(const MaterialApp(
    title: 'mock test',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final calc = Calc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          calc.value.toString(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            calc.increment();
          });
        },
        tooltip: 'tooltip',
        child: const Icon(Icons.add),
      ),
    );
  }
}
