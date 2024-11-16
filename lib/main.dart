import 'package:flutter/material.dart';
import 'package:loopa/utils/loopa.dart';
import 'package:loopa/views/default_view.dart';
import 'package:loopa/views/expanded_view.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
            body: SafeArea(
                child: MyHomePage() // todo: add loading state
            )
        )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ super.key });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool expandedState = true;
  Loopa loopa = Loopa();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Builder(
          builder: (BuildContext context) {
            if (expandedState) {
              return DefaultView(
                onToolbarPressed: onToolbarPressed,
                loopa: loopa,
              );
            } else {
              return ExpandedView(
                onToolbarPressed: onToolbarPressed,
                loopa: loopa,
              );
            }
          }
        )
      ),
    );
  }

  void onToolbarPressed() {
    setState(() {
      expandedState = !expandedState;
    });
  }
}