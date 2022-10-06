import 'package:flutter/material.dart';

class MenuRow extends StatefulWidget {
  const MenuRow({Key? key}) : super(key: key);

  @override
  State<MenuRow> createState() => _MenuRowState();
}

bool menuDown = false;

class _MenuRowState extends State<MenuRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text("REC", style: TextStyle(fontSize: 11.0, color: Colors.grey[300]),),
                          CircleAvatar(
                            backgroundColor: Colors.redAccent[700], //isRecording? Colors.redAccent[700] : Color.fromRGBO(51, 0, 0, 1),
                            radius: 15,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text("PLAY", style: TextStyle(fontSize: 11.0, color: Colors.grey[300]),),
                        CircleAvatar(
                          backgroundColor: Colors.lightGreenAccent[400], //appPhase[loopSelector - 1] == 3? Colors.lightGreenAccent[400] : Colors.green[900],
                          radius: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: menuDown? const Icon(Icons.keyboard_arrow_up_rounded) : const Icon(Icons.keyboard_arrow_down_rounded),
                  color: Colors.grey[300],
                  onPressed: () {
                    setState(() {
                      menuDown = !menuDown;
                    });
                  },
                ),
              ),
              const Expanded(
                child: Text("TEXT"),
              )
            ],
          ),
        ),
      ),
    );
  }
}