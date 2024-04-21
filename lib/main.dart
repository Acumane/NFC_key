import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'biometric.dart';
import 'nfc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',  // Assuming the Biometric Page is the first page
      routes: {
        '/': (context) => const BiometricPage(title: "Biometric Authentication Home"),
        '/nfc': (context) => NFCApp(),
      },
    );
  }
}
