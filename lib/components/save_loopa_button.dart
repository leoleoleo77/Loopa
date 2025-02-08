import 'package:flutter/material.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class SaveLoopaButton extends StatefulWidget {
  final Loopa loopa;

  const SaveLoopaButton({
    super.key,
    required this.loopa
  });

  @override
  State<SaveLoopaButton> createState() => _SaveLoopaButtonState();
}

class _SaveLoopaButtonState extends State<SaveLoopaButton> {
  bool isSaved = false;

  void _toggleSave() {
    if (isSaved) {
      print("loopa un-saved");
    } else {
      widget.loopa.save();
      print("loopa saved");
    }
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 60,
      decoration: _getBordersDecoration(),
      child: InkWell(
        onTap: _toggleSave,
        // style: OutlinedButton.styleFrom(
        //   backgroundColor: isSaved ? Colors.red : LoopaColors.neonGreen, // Toggle color
        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(0),
        //   ),
        //   side: BorderSide(
        //     color: LoopaColors.neonGreen,   // Outline color// Outline thickness
        //   ),
        // ),
        child: Text(
          isSaved ? 'Unsave' : 'Save',
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
          ),
        ),
      ),
    );
  }

  // todo add the logic to toggle this
  BoxDecoration _getBordersDecoration() {
    return BoxDecoration(
      color: LoopaColors.neonGreen,
      // border: Border.all(
      //     color: LoopaColors.neonGreen,  // Color of left and right borders
      //     width: 2,              // Thickness of left and right borders
      //   ),

    );
  }
}
