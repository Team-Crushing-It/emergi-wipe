import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/on_off_switch.dart';
import 'package:flutter_bluetooth/speed_bar.dart';

class SpeedManager extends StatefulWidget {
  @override
  _SpeedManagerState createState() => _SpeedManagerState();
}

class _SpeedManagerState extends State<SpeedManager> {
  int speed = 0;
  int lastSpeed = 0;
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Stack(children: [
            Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                      image: Theme.of(context).brightness == Brightness.dark
                          ? AssetImage("assets/Dark Logo.png")
                          : AssetImage("assets/EmerWipeLogo.png")),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dy > 0 && speed > 0) {
                        setState(() {
                          speed -= 1;
                          lastSpeed = speed;
                        });
                      } else if (details.velocity.pixelsPerSecond.dy < 0 && speed < 6) {
                        setState(() {
                          speed += 1;
                          lastSpeed = speed;
                        });
                      }
                    },
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.arrow_upward),
                              Text("Swipe", style: TextStyle(fontSize: 25)),
                              Icon(Icons.arrow_downward)
                            ],
                          ),
                          Column(
                            children: [
                              SpeedBar(value: 6, currentSpeed: lastSpeed, length: 280),
                              SpeedBar(value: 5, currentSpeed: lastSpeed, length: 230),
                              SpeedBar(value: 4, currentSpeed: lastSpeed, length: 180),
                              SpeedBar(value: 3, currentSpeed: lastSpeed, length: 130),
                              SpeedBar(value: 2, currentSpeed: lastSpeed, length: 80),
                              SpeedBar(value: 1, currentSpeed: lastSpeed, length: 30),
                              Text("$speed")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  OnOffSwitch(
                      isOn: isOn,
                      onTap: () {
                        setState(() {
                          isOn = !isOn;
                          if (isOn) {
                            speed = lastSpeed;
                          } else {
                            speed = 0;
                          }
                        });
                      })
                ]),
          ]),
        ));
  }
}

class DebugBorder extends StatelessWidget {
  final Widget child;

  const DebugBorder({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(border: Border.all(width: 2)), child: child);
  }
}
