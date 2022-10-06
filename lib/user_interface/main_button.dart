import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {
  const MainButton({Key? key}) : super(key: key);

  @override
  State<MainButton> createState() => _RootPageState();
}

bool buttonPressed = false;

class _RootPageState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("hello");
        setState(() {
          buttonPressed = !buttonPressed;
        });
      },
      child: buttonPressed? Image.asset("images/finalPedal.jpg") : Image.asset("images/finalPedal2.jpg")
    );//Image.asset("images/finalPedal2.jpg"),
  }
}