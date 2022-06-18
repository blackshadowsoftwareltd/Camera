import 'dart:async';
import 'package:flutter/services.dart';

const platform = MethodChannel('samples.flutter.dev/battery');

Future<void> getBatteryLevel() async {
  String batteryLevel;
  try {
    final int result = await platform.invokeMethod('getBatteryLevel');
    batteryLevel = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    batteryLevel = "Failed to get battery level: '${e.message}'.";
  }
}
