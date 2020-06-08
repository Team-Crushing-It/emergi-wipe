import 'package:flutter/material.dart';

import 'speed_bar.dart';

class SpeedPyramid extends StatelessWidget {
  final int speed;

  const SpeedPyramid({this.speed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpeedBar(value: 6, currentSpeed: speed),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SpeedBar(value: 5, currentSpeed: speed),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SpeedBar(value: 4, currentSpeed: speed),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: SpeedBar(value: 3, currentSpeed: speed),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: SpeedBar(value: 2, currentSpeed: speed),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: SpeedBar(value: 1, currentSpeed: speed),
        ),
      ],
    );
  }
}
