import 'package:flutter/material.dart';
import 'package:loopa_v2/user_interface/main_button.dart';
import 'package:loopa_v2/user_interface/main_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          MainMenu(),
          MainButton(),
        ],
      ),
    );
  }
}