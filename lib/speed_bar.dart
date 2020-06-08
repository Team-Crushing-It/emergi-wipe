import 'package:flutter/material.dart';

class SpeedBar extends StatelessWidget {
  final int value;
  final int currentSpeed;
  final double length;

  const SpeedBar({this.value, this.currentSpeed, this.length});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: length,
      height: 25,
      decoration: BoxDecoration(
        color: value <= currentSpeed ? Colors.yellow : Colors.grey,
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}