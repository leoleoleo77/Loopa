import 'package:flutter/material.dart';
import 'package:loopa/utils/loopa.dart';
import 'package:loopa/utils/permission_handler.dart';
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
  final ValueNotifier<Loopa> _loopaNotifier =
    ValueNotifier<Loopa>(Loopa(id: 0));

  // TODO: handle initialization
  @override
  void initState() {
    super.initState();
    PermissionHandler.requestPermissions();
    Loopa.setLoopaNotifier(_loopaNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ValueListenableBuilder<Loopa>(
          valueListenable: _loopaNotifier,
           builder: (context, loopaState, child) {
            if (expandedState) {
              return DefaultView(
                onToolbarPressed: onToolbarPressed,
                loopa: _loopaNotifier.value,
              );
            } else {
              return ExpandedView(
                onToolbarPressed: onToolbarPressed,
                loopa: _loopaNotifier.value,
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