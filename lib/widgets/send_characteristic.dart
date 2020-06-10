
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
    for(BluetoothService service in services) {
      if (service.uuid.toString() == "0000dfb0-0000-1000-8000-00805f9b34fb"){
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString() == "0000dfb1-0000-1000-8000-00805f9b34fb") {
            c.write(utf8.encode(stringValue), withoutResponse: true);
          }
      }
    }
}
}