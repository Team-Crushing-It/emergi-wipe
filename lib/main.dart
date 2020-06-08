// For performing some operations asynchronously
import 'dart:async';
import 'dart:convert';

// For using PlatformException
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/speed_manager.dart';
import 'package:flutter_bluetooth/widgets/emergi_wipe_logo.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        backgroundColor: Colors.white,
        accentColor: Colors.black,
        primaryColor: Colors.yellow,
        brightness: Brightness.light,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        fontFamily: "Courier Prime",
      ),
      darkTheme: ThemeData(
        backgroundColor: Colors.grey[900],
        accentColor: Colors.white,
        primaryColor: Colors.yellow,
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        fontFamily: "Courier Prime",
      ),
      home: BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;
  PageController _pageController;

  int _deviceState;
  bool _isOn;

  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // off
    _isOn = false;
    _pageController = PageController(
      initialPage: 1
    );

    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
    void showAlert(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("hi"),
              ));
    }
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    _pageController.dispose();
    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _devicesList = devices;
    });
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Connect Your Device", style: TextStyle(fontSize: 25)),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  EmergiWipeLogo(),
                  Visibility(
                    visible: _isButtonUnavailable && _bluetoothState == BluetoothState.STATE_ON,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.yellow,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Enable Bluetooth',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Switch(
                        value: _bluetoothState.isEnabled,
                        onChanged: (bool value) {
                          future() async {
                            if (value) {
                              await FlutterBluetoothSerial.instance.requestEnable();
                            } else {
                              await FlutterBluetoothSerial.instance.requestDisable();
                            }

                            await getPairedDevices();
                            _isButtonUnavailable = false;

                            if (_connected) {
                              _disconnect();
                            }
                          }

                          future().then((_) {
                            setState(() {});
                          });
                        },
                      )
                    ],
                  ),
                  Spacer(),
                  FlatButton.icon(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.black,
                    ),
                    label: Text("Refresh device list", style: TextStyle(fontSize: 16, color: Colors.black)),
                    onPressed: () async {
                      // So, that when new devices are paired
                      // while the app is running, user can refresh
                      // the paired devices list.
                      await getPairedDevices().then((_) {
                        show('Device list refreshed');
                      });
                    },
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Device:',
                        style: TextStyle(fontSize: 20),
                      ),
                      DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (value) => setState(() => _device = value),
                        value: _devicesList.isNotEmpty ? _device : null,
                      ),
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _isButtonUnavailable ? null : _connected ? _disconnect : _connect;
                          if(_connected) {
                            _pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(_connected ? 'Disconnect' : 'Connect', style: TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ],
                  ),
                  Spacer(flex: 6),
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text("Bluetooth Settings", style: TextStyle(fontSize: 16, color: Colors.black)),
                    onPressed: () {
                      FlutterBluetoothSerial.instance.openSettings();
                    },
                  ),
                  Spacer()
                ],
              ),
            ),
          ),
          Scaffold(
              appBar: AppBar(
                title: Text(
                  "Speed Controller",
                  style: TextStyle(fontSize: 25),
                ),
                centerTitle: true,
              ),
              body: SpeedManager(
                increaseSpeed: _increaseSpeed,
                decreaseSpeed: _decreaseSpeed,
                toggleOnOff: _toggleOnOff,
                isOn: _isOn,
                speed: _deviceState,
              ))
        ]);
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address).then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  _toggleOnOff() async {
    if (_isOn) {
      _sendOffMessageToBluetooth();
    } else {
      _sendOnMessageToBluetooth();
    }
  }

  // Method to send message,
  void _sendOnMessageToBluetooth() async {
//    connection.output.add(utf8.encode("$_deviceState" + "\r\n"));
//    await connection.output.allSent;
    show("operating on $_deviceState");
    setState(() {
      _isOn = true;
    });
  }

  // Method to send message,
  void _sendOffMessageToBluetooth() async {
//    connection.output.add(utf8.encode("0" + "\r\n"));
//    await connection.output.allSent;
    show("operating on 0");
    setState(() {
      _isOn = false;
    });
  }

  _increaseSpeed() {
    if (_isOn) {
      _sendStateMessageToBluetooth(_deviceState + 1);
    } else {
      show("cannot change speed while off");
    }
  }

  _decreaseSpeed() {
    if (_isOn) {
      _sendStateMessageToBluetooth(_deviceState - 1);
    } else {
      show("cannot change speed while off");
    }
  }

  void _sendStateMessageToBluetooth(int number) async {
//    connection.output.add(utf8.encode("$number" + "\r\n"));
//    await connection.output.allSent;
    show('Operating on speed $number');
    setState(() {
      _deviceState = number;
    });
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}