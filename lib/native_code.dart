// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/services.dart';

const platform = MethodChannel('CHANNEL');

Future<void> getBatteryLevel() async {
  String batteryLevel;
  try {
    final int result = await platform.invokeMethod('getBatteryLevel');
    batteryLevel = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    batteryLevel = "Failed to get battery level: '${e.message}'.";
  }
  print(batteryLevel);
}

Future<bool?> airplanMode() async {
  try {
    final bool resutl = await platform.invokeMethod('airplanMode');
    return resutl;
  } on PlatformException catch (e) {
    print('err: $e');
    return null;
  }
}
