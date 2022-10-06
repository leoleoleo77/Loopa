import 'package:flutter/material.dart';
import 'package:loopa_v2/user_interface/menu_row.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _RootPageState();
}

class _RootPageState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return const MenuRow();
  }
}