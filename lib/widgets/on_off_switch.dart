import 'package:flutter/material.dart';

//==========================================================================================================
// A switch that toggles whether the device is on or off
//==========================================================================================================
class OnOffSwitch extends StatelessWidget {
  final bool isOn;
  final Function onTap;

  const OnOffSwitch({this.isOn, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isOn ? Colors.grey : Colors.red,
                  ),
                  width: 70,
                  height: 50,
                  child: Center(child: Text("Off", style: TextStyle(fontSize: 20)))),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isOn ? Colors.lightGreenAccent : Colors.grey,
                  ),
                  width: 70,
                  height: 50,
                  child: Center(child: Text("On", style: TextStyle(fontSize: 20)))),
            ],
          )),
    );
  }
}