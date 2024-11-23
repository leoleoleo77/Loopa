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
  late Loopa _loopa = Loopa();


  // TODO: handle initialization
  @override
  void initState() {
    super.initState();
    //_loopa = Loopa();
    Loopa.requestPermissions();
  }

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
                loopa: _loopa,
              );
            } else {
              return ExpandedView(
                onToolbarPressed: onToolbarPressed,
                loopa: _loopa,
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