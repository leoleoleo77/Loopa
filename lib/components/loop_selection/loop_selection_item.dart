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
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                _getLoopaName(),
                _getMemoryInfoTextOrDancingNote()
              ],
            ),
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

  Widget _getMemoryInfoTextOrDancingNote() {
    if (Loopa.getStateFromMap(widget.id) != LoopaState.playing) {
      return _getMemoryInfoText();
    } else {
      return _getDancingNote();
    }
  }

  Widget _getMemoryInfoText() {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Column(
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
      ),
    );
  }

  Widget _getDancingNote() {
    return SvgPicture.asset(
      _noteAsset,
      width: LoopaSpacing.dancingNoteWidth,
      height: LoopaSpacing.dancingNoteHeight,
    );
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
            fontFamily: LoopaFontFamily.retro,
            height: 1,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColor() {
    if (Loopa.getStateFromMap(widget.id) == LoopaState.initial) {
      return LoopaColors.idleGreenGradient;
    } else {
      return LoopaColors.activeGreenGradient;
    }
  }

  // Kinda disgusting but there was a 16px space in each side that I had to get rid of
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