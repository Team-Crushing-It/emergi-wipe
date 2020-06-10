import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/emergi_wipe_logo.dart';
import 'widgets/on_off_switch.dart';
import 'widgets/speed_pyramid.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth/widgets/send_characteristic.dart';
import 'globals.dart' as globals;

//import 'package:flutter_bluetooth/widgets/send_characteristic.dart';
//==========================================================================================================
// Screen that user gestures on to change speed of device
//==========================================================================================================
class SpeedManager extends StatefulWidget {
  
  final BluetoothDevice device;

  const SpeedManager({Key key, this.device} ) : super(key: key);

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
        // User can swipe anywhere on the middle portion of the screen to change speed
        // Does not allow swiping when off
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragEnd: (details) {
            if(isOn) {
              if (details.velocity.pixelsPerSecond.dy > 0 && speed > 1) {
                sendChar(speed - 1);
                setState(() {
                  speed -= 1;
                });
              } else if (details.velocity.pixelsPerSecond.dy < 0 && speed < 6) {
                sendChar(speed + 1);
                setState(() {
                  speed += 1;
                });
              }
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
               sendChar(0);
              } else {
                sendChar(speed);
              }
              setState(() {
                isOn = !isOn;
              });
            })
      ]),
    );
  }
}