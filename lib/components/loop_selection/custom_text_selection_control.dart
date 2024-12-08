import 'package:flutter/material.dart';

class CustomTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildHandle(
      BuildContext context,
      TextSelectionHandleType type,
      double textHeight,
      [void Function()? onTap]
  ) {
    return Container();
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return Size.zero; // No size for the handle
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return Offset.zero; // No anchor needed
  }
}
