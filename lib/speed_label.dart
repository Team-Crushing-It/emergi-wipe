import 'package:flutter/material.dart';

class SpeedLabel extends StatelessWidget {
  final String text;
  final int value;
  final int currentSpeed;

  const SpeedLabel({this.text, this.value, this.currentSpeed});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: value == currentSpeed ? Colors.green : Colors.grey,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 25),
        ));
  }
}
