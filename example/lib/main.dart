import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_lanka_clear_sdk/flutter_lcsdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _init = false, _created = false, _isIdentityExists = false;
  String _version = 'Unknown';
  String _deviceId = 'Unknown';
  String _message = 'Unknown';
  String _challenge = 'my_challenge';

  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }
  Future<String> _getLCVersion() async {
    final String version = await FlutterLCSDK.getVersion;
    setState(() {
      _version = version;
    });
    return version;
  }

  Future<bool> _initSDK() async {
    final bool status = await FlutterLCSDK.init();
    setState(() {
      this._init = status;
    });
    return status;
  }

  Future<bool> _createIdentity() async {
    _challenge = "test challenge";
    try {
      bool created = await FlutterLCSDK.createIdentity(this._challenge);
      setState(() {
        this._created = created;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        this._created = false;
      });
    }

    return _created;
  }
  Future<bool> _checkIdentityExists() async {
    final bool isIdentityExists = await FlutterLCSDK.isIdentityExists;

    setState(() {
      this._isIdentityExists = isIdentityExists;
    });

    return _isIdentityExists;
  }
  Future<String> _signMessage() async {
    String message = "my message";

    try {
      final String signedMessage = await FlutterLCSDK.signMessage(message);
      print(signedMessage);
      setState(() {
        this._message = signedMessage;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        this._message = e.message;
      });
    }

    return _message;
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> _getDeviceId() async {
    final String deviceId = await FlutterLCSDK.deviceId;
    setState(() {
      this._deviceId = deviceId;
    });
    return deviceId;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('LC SDK example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("INIT SDK"),
                  onPressed: () {
                    this._initSDK();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Status: $_init")
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("GET VERSION"),
                  onPressed: () {
                    this._getLCVersion();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Version: $_version")
              ],
            ),
            RaisedButton(
              child: Text("GET DEVICE ID"),
              onPressed: () {
                this._getDeviceId();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text("Device Id: $_deviceId"),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("IS IDENTITY EXISTS"),
                  onPressed: () {
                    this._checkIdentityExists();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text("$_isIdentityExists")
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("CREATE IDENTITY"),
                  onPressed: () {
                    this._createIdentity();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Created: $_created")
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("SIGN MESSAGE"),
                  onPressed: () {
                    this._signMessage();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Message: $_message")
              ],
            )
          ],
        ),
      ),
    );
  }
}
