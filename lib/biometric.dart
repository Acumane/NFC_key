import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Biometric Authentication',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BiometricPage(title: 'Biometric Authentication Home'),
    );
  }
}

class BiometricPage extends StatefulWidget {
  const BiometricPage({super.key, required this.title});

  final String title;

  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  final int _counter = 0;
  final TextEditingController _mobileNumberController = TextEditingController();
  String _statusMessage = '';

  Future<void> initiateBiometricAuth(String mobileNumber) async {
    setState(() {
      _statusMessage = "Initiating authentication...";
    });

    var headers = {
      'x-api-key': 'nyYqjcdsP41jrEMpL3W7z2JzV6FRCxhmahXjY3tZ', // Replace 'iVALT_TOKEN' with your actual API key
      'Content-Type': 'application/json',
    };

    var response = await http.post(
      Uri.parse('https://api.ivalt.com/biometric-auth-request'),
      headers: headers,
      body: json.encode({"mobile": mobileNumber}),
    );

    if (response.statusCode == 200) { // replace with response.statusCode == 200
      setState(() {
        Navigator.of(context).pushNamed('/nfc');
        _statusMessage = "Authentication initiated, check your device.";
      });
    } else {
      setState(() {
        _statusMessage = "Failed to initiate authentication: ${response.body}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                controller: _mobileNumberController,
                decoration: InputDecoration(
                  labelText: "Enter your mobile number",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _mobileNumberController.clear(),
                  ),
                ),
              keyboardType: TextInputType.phone,
              ),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_mobileNumberController.text.isNotEmpty) {
                  initiateBiometricAuth(_mobileNumberController.text);
                } else {
                  setState(() {
                    _statusMessage = "Please enter a mobile number.";
                  });
                }
              },
              child: const Text('Authenticate'),
            ),
            const SizedBox(height: 20),
            Text(_statusMessage),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
      
    );
  }
}
