import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
        primarySwatch: Colors.blue,
      ),
      home: const BiometricPage(title: 'Biometric Authentication'),
      debugShowCheckedModeBanner: false,
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
  final TextEditingController _mobileNumberController = TextEditingController();

  Future<void> initiateBiometricAuth(String mobileNumber) async {
    showSnackbar("Initiating authentication...");
    const Duration pollInterval = Duration(seconds: 2); // Adjust the interval as needed

    var headers = {
      'x-api-key': 'nyYqjcdsP41jrEMpL3W7z2JzV6FRCxhmahXjY3tZ',
      'Content-Type': 'application/json',
    };

    // Make the initial authentication request
    var authRequestResponse = await http.post(
      Uri.parse('https://api.ivalt.com/biometric-auth-request'),
      headers: headers,
      body: json.encode({"mobile": mobileNumber}),
    );

    if (authRequestResponse.statusCode != 200) {
      // If the initial request fails, show error message and return
      showSnackbar("Failed to initiate authentication");
      return;
    }

    // Start polling for authentication result
    Timer.periodic(pollInterval, (timer) async {
      var authResultResponse = await http.post(
        Uri.parse('https://api.ivalt.com/biometric-auth-result'),
        headers: headers,
        body: json.encode({"mobile": mobileNumber}),
      );

      print(authResultResponse.body);

      if (authResultResponse.statusCode == 200) {
        Navigator.of(context).pushNamed('/nfc');
        showSnackbar("Authentication initiated, check your device.");
        timer.cancel(); // Stop polling
      }
    });
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _mobileNumberController,
                decoration: InputDecoration(
                  labelText: "Enter your mobile number",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _mobileNumberController.clear,
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text('Authenticate'),
                onPressed: () {
                  if (_mobileNumberController.text.isNotEmpty) {
                    initiateBiometricAuth(_mobileNumberController.text);
                  } else {
                    showSnackbar("Please enter a mobile number.");
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
