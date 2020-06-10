// TCi Summer 2020

import 'dart:async';
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:flutter_bluetooth/widgets.dart';
import 'package:flutter_bluetooth/speed_manager.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/widgets/emergi_wipe_logo.dart';
import 'package:flutter_bluetooth/widgets/on_off_switch.dart';
import 'package:flutter_bluetooth/widgets/speed_bar.dart';
import 'package:flutter_bluetooth/widgets/speed_pyramid.dart';
import 'package:flutter_bluetooth/widgets/send_characteristic.dart';


void main() {
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
//==========================================================================================================
class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SpeedManager(device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return SpeedManager(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

//================================================================================================

// class SpeedManager extends StatefulWidget {
//   const SpeedManager({Key key, this.device}) : super(key: key);

//   final BluetoothDevice device;

  
// //==========================================================================================================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
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
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dy > 0 && speed > 1) {
             // widget.setSpeed(speed - 1);
              sendChar(speed-1);
              setState(() {
                speed -= 1;
              });
            } else if (details.velocity.pixelsPerSecond.dy < 0 && speed < 6) {
            //  widget.setSpeed(speed + 1);
              sendChar(speed+1);
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
             //   widget.setSpeed(0);
              } else {
             //   widget.setSpeed(speed);
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
