import 'package:flutter/material.dart';

class SpeedBar extends StatelessWidget {
  final int value;
  final int currentSpeed;
  final bool isOn;

  const SpeedBar({this.value, this.currentSpeed, this.isOn});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 25,
      decoration: BoxDecoration(
        //Could you write out this logic here? This nested if statement is pretty hard to read and understand
        color: isOn ? value <= currentSpeed ? Colors.yellow : Colors.grey : value <= currentSpeed ? Color(0xFF605816) : Color(0xFF3B3B3B),
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}