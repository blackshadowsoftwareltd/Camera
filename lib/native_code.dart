import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const channel = MethodChannel('channel');

Future<void> getBatteryLevel() async {
  try {
    final result = await channel.invokeMethod('getBatteryLevel');
    debugPrint(result);
  } on PlatformException catch (e) {
    debugPrint('ERR: $e');
  } catch (e) {
    debugPrint('ERR: $e');
  }
}
