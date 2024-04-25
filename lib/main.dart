import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final TextEditingController log = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('NFC Key')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: log,
                readOnly: true, // Make TextField read-only if you only want it to display text
              ),
              SizedBox(height: 20), // Space between the button and the TextField
              ElevatedButton(
                onPressed: readNFC,
                child: const Text('Read'),
              ),
              SizedBox(height: 20), // Space between the buttons
              ElevatedButton(
                onPressed: writeNFC,
                child: const Text('Write'),
              ),
              // Add a TextField to display the text
            ],
          ),
        ),
      ));
  }

  @override
  void dispose() {
    // Always dispose of your controllers to avoid memory leaks.
    log.dispose();
    super.dispose();
  }

  void readNFC() async {
    try {
      bool hasNFC = await NfcManager.instance.isAvailable();

      if (hasNFC) {
        setState(() { log.text += 'Reading, approach NFC tag...\n'; });
        NfcManager.instance.startSession( // listen 'til tag discovered
          onDiscovered: (NfcTag tag) async {
            setState(() { log.text += 'Detected: ${tag.data}\n'; });
            Ndef? ndef = Ndef.from(tag);
            if (ndef == null) {
              setState(() { log.text += 'Tag doesn\'t support NDEF'; });
              return;
            }
            setState(() { log.text += 'NDEF data: $ndef\n'; });
          },
        );
      } else { setState(() { log.text += 'NFC disabled\n'; }); }
    } catch (e) {
      setState(() { log.text += 'Read error: $e\n'; });
    }
  }

  void writeNFC() async {
    try {
      bool hasNFC = await NfcManager.instance.isAvailable();

      if (hasNFC) { 
        setState(() { log.text += 'Writing, approach NFC tag...\n'; });
        NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {

        try {
          NdefMessage message = NdefMessage([NdefRecord.createText('Test message')]);
          await Ndef.from(tag)?.write(message); // Support NDEF? -> write message
          setState(() { log.text += 'Data emitted!\n'; });
          Uint8List payload = message.records.first.payload;
          String text = String.fromCharCodes(payload);
          setState(() { log.text += 'Written data: $text\n'; });

          NfcManager.instance.stopSession();
        } catch (e) {
          setState(() { log.text += 'Error emitting NFC data: $e\n'; });
        }
      });
      } else {
        setState(() { log.text += 'NFC not available.\n'; });
      }
    } catch (e) {
      setState(() { log.text += 'Error writing to NFC: $e\n'; });
    }
  }
}