import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loopa/main/bloc/main_bloc.dart';
import 'package:loopa/main/bloc/main_state.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/views/default_view.dart';
import 'package:loopa/views/expanded_view.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';




void main() async {
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized()); // todo: make it nice
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: MyHomePage()
            )
        )
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({ super.key });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: mGetIt.get<MainBloc>()..init(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return Container(
            color: Colors.red,
            child: Padding(
              padding: LoopaPadding.vertical16,
              child: state.expandedState
                  ? const ExpandedView()
                  : const DefaultView()
            ),
          );
        }
      ),
    );
  }
}