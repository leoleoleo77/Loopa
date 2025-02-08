import 'package:flutter/material.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class PlayRecLights extends StatelessWidget {
  final ValueNotifier<LoopaState> loopaStateNotifier;

  const PlayRecLights({
    super.key,
    required this.loopaStateNotifier
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _getRecLight(),
        const SizedBox(width: LoopaSpacing.spacing8),
        _getPlayLight(),
      ],
    );
  }

  Widget _getRecLight() {
    return Column(
      children: [
        const Text(
          LoopaText.rec,
          style: LoopaTextStyle.menuLabels
        ),
        const SizedBox(height: LoopaSpacing.spacing4),
        _getRedCircleAvatar(),
      ],
    );
  }

  Widget _getRedCircleAvatar() {
    return Stack(
      children: [
        _getCircleAvatarBackground(),
        ValueListenableBuilder<LoopaState>(
          valueListenable: loopaStateNotifier,
          builder: (context, loopaState, child) {
            Color redAccent;
            if (loopaState == LoopaState.recording) {
              redAccent = LoopaColors.red;
            } else {
              redAccent = LoopaColors.inactiveRecLightRed;
            }

            return CircleAvatar(
              radius: LoopaConstants.playRecLightsRadius,
              backgroundColor: redAccent,
            );
          },
        ),
      ],
    );
  }

  Widget _getPlayLight() {
    return Column(
      children: [
        const Text(
          LoopaText.play,
          style: LoopaTextStyle.menuLabels
        ),
        const SizedBox(height: LoopaSpacing.spacing4),
        _getGreenCircleAvatar()
      ],
    );
  }

  Widget _getGreenCircleAvatar() {
    return Stack(
      children: [
        _getCircleAvatarBackground(),
        ValueListenableBuilder<LoopaState>(
          valueListenable: loopaStateNotifier,
          builder: (context, loopaState, child) {
            Color greenAccent;
            if (loopaState == LoopaState.playing) {
              greenAccent = LoopaColors.green;
            } else {
              greenAccent = LoopaColors.inactivePlayLightGreen;
            }

            return CircleAvatar(
              radius: LoopaConstants.playRecLightsRadius,
              backgroundColor: greenAccent,
            );
          },
        ),
      ],
    );
  }

  Widget _getCircleAvatarBackground() {
    return const CircleAvatar(
      radius: LoopaConstants.playRecLightsRadius,
      backgroundColor: LoopaColors.playRecLightBackground
    );
  }
}