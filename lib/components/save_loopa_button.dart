import 'package:flutter/material.dart';
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
    return ElevatedButton(
      onPressed: _toggleSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSaved ? Colors.red : Colors.green, // Toggle color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        isSaved ? 'Unsave' : 'Save',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
