import 'dart:async';

import 'package:flutter/services.dart';

class FlutterLCSDK {
  static const MethodChannel _channel =
      const MethodChannel('flutter_lanka_clear_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future init() async {
    await _channel.invokeMethod("init");
  }

  static Future clearCertificate() async {
    await _channel.invokeMethod("clearCertificate");
  }

  static Future<bool> createIdentity(String challenge) async {
    try {
      final bool result = await _channel
          .invokeMethod('createIdentity', {'challenge': challenge});
      return result;
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<String> signMessage(String message) async {
    try {
      final String result =
          await _channel.invokeMethod('signMessage', {'message': message});

      return result;
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<String> get getVersion async {
    final String version = await _channel.invokeMethod("getVersion");
    return version;
  }

  static Future<bool> get isIdentityExists async {
    final bool isIdentityExist = await _channel.invokeMethod("isIdentityExist");
    return isIdentityExist;
  }

  static Future<String> get deviceId async {
    return await _channel.invokeMethod("getDeviceID");
  }
}
