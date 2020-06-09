import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/widgets/emergi_wipe_logo.dart';
import 'package:flutter_bluetooth/widgets/on_off_switch.dart';
import 'package:flutter_bluetooth/widgets/speed_bar.dart';
import 'package:flutter_bluetooth/widgets/speed_pyramid.dart';
//import 'package:flutter_bluetooth/widgets/send_characteristic.dart';

class SpeedManager extends StatefulWidget {
  final Function setSpeed;

  const SpeedManager({this.setSpeed});

  @override
  _SpeedManagerState createState() => _SpeedManagerState();
}

class _SpeedManagerState extends State<SpeedManager> {
  int speed = 0;
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: EmergiWipeLogo(),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dy > 0 && speed > 0) {
              widget.setSpeed(speed - 1);
              //sendChar(speed-1);
              setState(() {
                speed -= 1;
              });
            } else if (details.velocity.pixelsPerSecond.dy < 0 && speed < 6) {
              widget.setSpeed(speed + 1);
              //sendChar(speed+1);
              setState(() {
                speed += 1;
              });
            }
          },
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.arrow_upward), Text("Swipe", style: TextStyle(fontSize: 18)), Icon(Icons.arrow_downward)],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SpeedPyramid(speed: speed, isOn: isOn),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
        OnOffSwitch(
            isOn: isOn,
            onTap: () {
              if(isOn) {
                widget.setSpeed(0);
              } else {
                widget.setSpeed(speed);
              }
              setState(() {
                isOn = !isOn;
              });
            })
      ]),
    );
  }
}

class DebugBorder extends StatelessWidget {
  final Widget child;

  const DebugBorder({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 3)), child: child);
  }
}

