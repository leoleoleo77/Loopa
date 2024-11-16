import 'package:flutter/material.dart';
import 'package:loopa/components/loop_button.dart';
import 'package:loopa/loopa.dart';

class ExpandedView extends StatelessWidget {
  final VoidCallback onToolbarPressed;
  final Loopa loopa;

  const ExpandedView({
    super.key,
    required this.onToolbarPressed,
    required this.loopa
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getDropDownToolBar(),
        const SizedBox(height: 8),
        LoopButton(
          largeState: false,
          updateLoopaState: loopa.updateState,
        )
      ],
    );
  }

  Widget _getDropDownToolBar() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
                height: 600,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(21, 21, 21, 1),
                        Color.fromRGBO(24, 24, 24, 1),
                        Color.fromRGBO(24, 24, 24, 1),
                        Color.fromRGBO(28, 28, 28, 1),
                        Color.fromRGBO(31, 31, 31, 1)
                      ]
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: onToolbarPressed,
                        child: SizedBox(
                          height: 44,
                          width: double.infinity,
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(21, 21, 21, 1),
                                  spreadRadius: 1,                       // Extent of shadow
                                  blurRadius: 10,
                                ),
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(24, 24, 24, 1),
                                    Color.fromRGBO(21, 21, 21, 1),
                                  ]
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(4),
                                bottom: Radius.circular(8)
                              )
                            ),
                            child: const Icon(
                              Icons.menu_rounded,
                              size: 32,
                              color: Color.fromRGBO(31, 31, 31, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ) // temp
            ),
          ),
        ),
      ],
    );
  }
}