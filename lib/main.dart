import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _nfcData = 'NFC tag data will appear here';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter NFC Kit Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_nfcData),
              ElevatedButton(
                child: Text('Read NFC'),
                onPressed: () async {
                  var availability = await FlutterNfcKit.nfcAvailability;
                  if (availability == NFCAvailability.available) {
                    try {
                      var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10),
                          iosMultipleTagMessage: "More than one tag is found", iosAlertMessage: "Hold your device near the tag");
                      setState(() {
                        _nfcData = tag.toString();
                      });
                    } catch (e) {
                      setState(() {
                        _nfcData = 'Failed to read NFC: $e';
                      });
                    }
                  } else {
                    setState(() {
                      _nfcData = 'NFC not available';
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
