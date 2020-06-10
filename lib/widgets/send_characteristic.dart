
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth/main.dart';
import 'dart:convert';
import 'package:flutter_bluetooth/globals.dart' as globals;

void sendChar(int i) async{
    print(i);
    String stringValue = i.toString();
  globals.isLoggedIn = true;

    final BluetoothDevice device=globals.gdevice;

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
    });
/*    var characteristics = service.characteristics;

    for(BluetoothCharacteristic c in characteristics) {
      if (service.uuid.toString() == "0000dfb0-0000-1000-8000-00805f9b34fb"){
        if (c.uuid.toString() == "0000dfb1-0000-1000-8000-00805f9b34fb") {
          c.write(utf8.encode(stringValue), withoutResponse: true);
        }
      }
    }*/
}




  /*
  @override
void sendMessageToDevice() async {
  print('ninot');
  print(characteristic);
}
FlutterBlue.instance.connectedDevices;
List<BluetoothService> services = await device.discoverServices();
services.forEach((service) {
    // do something with service
});

    for(BluetoothCharacteristic c in characteristics) {
  if (service.uuid.toString() == "0000dfb0-0000-1000-8000-00805f9b34fb"){
    if (c.uuid.toString() == "0000dfb1-0000-1000-8000-00805f9b34fb") {
      List<int> value = await c.read();
      if (value.toString() == "[1]"){
        await c.write([0]);
      }
      else if (value.toString() == "[0]"){
        await c.write([1]);
      }          
    }
  }
}
*/


/*
for(BluetoothService service in services) {
        for(BluetoothCharacteristic c in service.characteristics) {
          if(c.uuid == new Guid("0000ffe1-0000-1000-8000-00805f9b34fb")) {
            _setNotification(c);
          } else {
            print("Nope");
          }
        }
      }*/