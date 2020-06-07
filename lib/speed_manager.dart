import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/on_off_switch.dart';
import 'package:flutter_bluetooth/speed_bar.dart';

class SpeedManager extends StatelessWidget {
  final Function increaseSpeed;
  final Function decreaseSpeed;
  final Function toggleOnOff;
  final int speed;
  final int isOn;

  const SpeedManager({this.increaseSpeed, this.decreaseSpeed, this.toggleOnOff, this.speed, this.isOn});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
                image: Theme.of(context).brightness == Brightness.dark ? AssetImage("assets/Dark Logo.png") : AssetImage("assets/EmerWipeLogo.png")),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy > 0 && speed > 0) {
                  decreaseSpeed;
                } else if (details.velocity.pixelsPerSecond.dy < 0 && speed < 6) {
                  increaseSpeed;
                }
              },
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.arrow_upward), Text("Swipe", style: TextStyle(fontSize: 25)), Icon(Icons.arrow_downward)],
                    ),
                    Column(
                      children: [
                        SpeedBar(value: 6, currentSpeed: speed, length: 280),
                        SpeedBar(value: 5, currentSpeed: speed, length: 230),
                        SpeedBar(value: 4, currentSpeed: speed, length: 180),
                        SpeedBar(value: 3, currentSpeed: speed, length: 130),
                        SpeedBar(value: 2, currentSpeed: speed, length: 80),
                        SpeedBar(value: 1, currentSpeed: speed, length: 30),
                      ],
                    )
                  ],
                ),
              ),
            ),
            OnOffSwitch(isOn: isOn > 0 ? true : false, onTap: toggleOnOff)
          ]),
    );
  }
}