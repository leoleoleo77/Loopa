import 'package:flutter/material.dart';
import 'package:loopa/utils/general_utils/constants.dart';
import 'package:loopa/utils/general_utils/service_locator.dart';
import 'package:loopa/utils/loopa_utils/loopa.dart';

class PlayRecLights extends StatelessWidget {

  const PlayRecLights({super.key,});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Loopa>(
        valueListenable: mGetIt.get<ValueNotifier<Loopa>>(),
        builder: (context, loopa, child) {
        return ValueListenableBuilder<LoopaState>(
            valueListenable: loopa.stateNotifier,
            builder: (context, loopaState, child) {
            return Row(
              children: [
                _getRecLight(loopaState),
                const SizedBox(width: LoopaSpacing.spacing8),
                _getPlayLight(loopaState),
              ],
            );
          }
        );
      }
    );
  }

  Widget _getRecLight(LoopaState loopaState) {
    return Column(
      children: [
        const Text(
          LoopaText.rec,
          style: LoopaTextStyle.menuLabels),
        const SizedBox(height: LoopaSpacing.spacing4),
        Stack(
          children: [
            _getCircleAvatarBackground(),
            CircleAvatar(
                radius: LoopaConstants.playRecLightsRadius,
                backgroundColor: loopaState == LoopaState.recording
                    ? LoopaColors.red
                    : LoopaColors.inactiveRecLightRed)])]);
  }

  Widget _getPlayLight(LoopaState loopaState) {
    return Column(
        children: [
          const Text(
              LoopaText.play,
              style: LoopaTextStyle.menuLabels),
          const SizedBox(height: LoopaSpacing.spacing4),
          Stack(
              children: [
                _getCircleAvatarBackground(),
                CircleAvatar(
                    radius: LoopaConstants.playRecLightsRadius,
                    backgroundColor: loopaState == LoopaState.playing
                        ? LoopaColors.green
                        : LoopaColors.inactivePlayLightGreen)])]);
  }

  Widget _getCircleAvatarBackground() {
    return const CircleAvatar(
      radius: LoopaConstants.playRecLightsRadius,
      backgroundColor: LoopaColors.playRecLightBackground
    );
  }
}