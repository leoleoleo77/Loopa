import 'package:flutter/material.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';
import 'package:loopa/utils/general_utils/permission_handler.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/views/default_view.dart';
import 'package:loopa/views/expanded_view.dart';

import 'utils/general_utils/constants.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
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
  bool _expandedState = true;

  // TODO: handle initialization
  // TODO: wrap main inside a bloc
  @override
  void initState() {
    super.initState();
    PermissionHandler.requestPermissions();
    Loopa.initializeLoopas();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: LoopaPadding.vertical16,
        child: ValueListenableBuilder<Loopa>(
          valueListenable: mGetIt.get<ValueNotifier<Loopa>>(),
           builder: (context, loopa, child) {
            if (_expandedState) {
              return DefaultView(
                onToolbarPressed: _onToolbarPressed);
            } else {
              return ExpandedView(
                onToolbarPressed: _onToolbarPressed);
            }
          }
        )
      ),
    );
  }

  void _onToolbarPressed() {
    setState(() {
      _expandedState = !_expandedState;
    });
  }
}