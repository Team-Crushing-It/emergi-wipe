import 'package:flutter/material.dart';
//==========================================================================================================
// A single bar of SpeedPyramid, changes colors to indicate speed
//==========================================================================================================
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
        color: getBarColor(),
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }

  // Returns color that SpeedBar should be
  Color getBarColor() {
    if(isOn) {
      if(value <= currentSpeed)
        return Colors.yellow;
      else
        return Colors.grey;
    } else {
      if(value <= currentSpeed)
        return Color(0xFF605816);
      else
        return Color(0xFF3B3B3B);
    }
  }
}