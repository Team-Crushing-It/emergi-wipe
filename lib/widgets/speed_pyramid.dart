import 'package:flutter/material.dart';

import 'speed_bar.dart';

//==========================================================================================================
// An inverted pyramid that visually represents the current speed
//==========================================================================================================
class SpeedPyramid extends StatelessWidget {
  final int speed;
  final bool isOn;

  const SpeedPyramid({this.speed, this.isOn});
  @override
  Widget build(BuildContext context) {
    // Uses padding to determine SpeedBar size for responsiveness
    return Column(
      children: [
        SpeedBar(value: 6, currentSpeed: speed, isOn: isOn),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SpeedBar(value: 5, currentSpeed: speed, isOn: isOn),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SpeedBar(value: 4, currentSpeed: speed, isOn: isOn),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: SpeedBar(value: 3, currentSpeed: speed, isOn: isOn),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: SpeedBar(value: 2, currentSpeed: speed, isOn: isOn),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: SpeedBar(value: 1, currentSpeed: speed, isOn: isOn),
        ),
      ],
    );
  }
}
