import 'package:flutter/material.dart';
import 'package:loopa/utils/loopa.dart';

class PlayRecLights extends StatelessWidget {
  final ValueNotifier<LoopaState> loopaStateNotifier;

  const PlayRecLights({
    super.key,
    required this.loopaStateNotifier
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          _getRecLight(),
          const SizedBox(width: 8),
          _getPlayLight(),
        ],
      ),
    );
  }

  Widget _getRecLight() {
    return Column(
      children: [
        Text(
          'REC',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        _getRedCircleAvatar(),
      ],
    );
  }

  Widget _getRedCircleAvatar() {
    return ValueListenableBuilder<LoopaState>(
      valueListenable: loopaStateNotifier,
        builder: (context, loopaState, child) {
          Color redAccent;
          if (loopaState == LoopaState.recording) {
            redAccent = Colors.red;
          } else {
            redAccent = Colors.red.withOpacity(0.15);
          }

          return CircleAvatar(
            radius: 20,
            backgroundColor: redAccent,
          );
      },
    );
  }

  Widget _getPlayLight() {
    return Column(
      children: [
        Text(
          'PLAY',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        _getGreenCircleAvatar()
      ],
    );
  }

  Widget _getGreenCircleAvatar() {
    return ValueListenableBuilder<LoopaState>(
      valueListenable: loopaStateNotifier,
      builder: (context, loopaState, child) {
        Color redAccent;
        if (loopaState == LoopaState.playing) {
          redAccent = Colors.green;
        } else {
          redAccent = Colors.green.withOpacity(0.1);
        }

        return CircleAvatar(
          radius: 20,
          backgroundColor: redAccent,
        );
      },
    );
  }
}