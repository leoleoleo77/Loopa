import 'package:flutter/material.dart';

class LoopSelectionItemState {
  final FocusNode? textFieldFocusNode;
  final String? displayName;
  final String? displayMemoryCount;

  LoopSelectionItemState({
    this.textFieldFocusNode,
    this.displayName,
    this.displayMemoryCount
  });

  LoopSelectionItemState copyWith({
    FocusNode? textFieldFocusNode,
    String? displayName,
    String? displayMemoryCount
  }) {
    return LoopSelectionItemState(
      textFieldFocusNode: textFieldFocusNode ?? this.textFieldFocusNode,
      displayName: displayName ?? this.displayName,
      displayMemoryCount: displayMemoryCount ?? this.displayMemoryCount
    );
  }
}