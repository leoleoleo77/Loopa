import 'package:flutter/material.dart';
import 'package:loopa/utils/general_utils/constants.dart';

class RangeSliderExample extends StatefulWidget {
  const RangeSliderExample({super.key});

  @override
  State<RangeSliderExample> createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  RangeValues _currentRangeValues = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Text("0", style: TextStyle(color: LoopaColors.softGrey),),
            Expanded(
              child: RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 100,
                divisions: 10,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
            ),
            Text("100", style: TextStyle(color: LoopaColors.softGrey),),
          ],
        ),
      ),
    );
  }
}
