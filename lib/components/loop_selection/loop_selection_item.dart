import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loopa/utils/constants.dart';
import 'package:loopa/utils/loopa.dart';

class LoopSelectionItem extends StatefulWidget {
  final int id;

  const LoopSelectionItem({
    super.key,
    required this.id
  });

  @override
  State<LoopSelectionItem> createState() => _LoopSelectionItemState();
}

class _LoopSelectionItemState extends State<LoopSelectionItem> {
  late final Timer _dancingNoteTimer;
  String _noteAsset = LoopaAssets.note1;

  @override
  void initState() {
    super.initState();
    _initializeDancingNoteTimer();
  }

  void _initializeDancingNoteTimer() {
    if (Loopa.getStateFromMap(widget.id) != LoopaState.playing) return;

    _dancingNoteTimer = Timer.periodic(
      LoopaDuration.milliseconds500,
      (_) {
        setState(() {
          if (_noteAsset == LoopaAssets.note1) {
            _noteAsset = LoopaAssets.note2;
          } else {
            _noteAsset = LoopaAssets.note1;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _dancingNoteTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          _getEdgesCover(leftEdge: true),
          _getEdgesCover(leftEdge: false),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getLoopaName(),
              _getMemoryInfoText(),
              _getDancingNote()
            ],
          ),
        ],
      ),
    );
  }

  Widget _getLoopaName() {
    return SizedBox(
      width: LoopaSpacing.selectionItemNameWidth,
      child: _getGradientText(
        text: Loopa.getNameFromMap(widget.id),
        fontSize: LoopaFontSize.fontSize36,
      ),
    );
  }

  Widget _getMemoryInfoText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getGradientText(
          text: LoopaText.memory,
          fontSize: LoopaFontSize.fontSize18,
        ),
        _getGradientText(
            text: widget.id.toString(),
            fontSize: LoopaFontSize.fontSize20
        ),
      ],
    );
  }

  Widget _getDancingNote() {
    if (Loopa.getStateFromMap(widget.id) == LoopaState.playing) {
      return Expanded(
        child: SvgPicture.asset(
          _noteAsset,
          width: LoopaSpacing.dancingNoteWidth,
          height: LoopaSpacing.dancingNoteHeight,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _getGradientText({
    required String text,
    required double fontSize,
  }) {
    return Transform.scale(
      scaleY: 1.5,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) {
          return LinearGradient(
              colors: _getGradientColor()
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          );
        },
        child: Text(
          text,
          style: TextStyle(
            fontFamily: LoopaFont.retro,
            height: 1,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColor() {
    // TODO: make this condition a bit clearer
    if (Loopa.getStateFromMap(widget.id) == LoopaState.initial) {
      return <Color>[
        Colors.lightGreenAccent.shade400.withOpacity(0.4),
        Colors.lightGreenAccent.shade400.withOpacity(0.4)
      ];
    } else {
      return <Color>[
        Colors.lightGreenAccent.shade400,
        Colors.lightGreenAccent.shade700
      ];
    }
  }

  // Kinda disgusting but there was a 16px space in each side
  Widget _getEdgesCover({required bool leftEdge}) {
    return Align(
      alignment: leftEdge
          ? AlignmentDirectional.bottomStart
          : AlignmentDirectional.bottomEnd,
      child: Transform.translate(
        offset: Offset(
            leftEdge ? -16 : 16,
            0
        ),
        child: Container(
          width: 16,
          height: double.infinity,
          color: Colors.black,
        ),
      ),
    );
  }
}