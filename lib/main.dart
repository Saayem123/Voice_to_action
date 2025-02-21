import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'services/nlp_service.dart';
import 'services/database_service.dart';



void main() {
  runApp(MaterialApp(
    home: SpeechToActionApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class SpeechToActionApp extends StatefulWidget {
  @override
  _SpeechToActionAppState createState() => _SpeechToActionAppState();
}

class _SpeechToActionAppState extends State<SpeechToActionApp> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the button and start speaking...";
  String _extractedTask = "No task detected";
  String _extractedDate = "No date detected";
  String _extractedTime = "No time detected";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    checkStoredActions(); // Fetch and check stored actions on app start
  }

  void checkStoredActions() async {
    List<Map<String, dynamic>> actions = await DatabaseService().fetchAllActions();
    print(actions); // Log database entries
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Status: $status"),
      onError: (error) => print("Error: $error"),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
      );
    } else {
      setState(() {
        _text = "Speech recognition is not available.";
      });
    }
  }

  void _stopListening() async {
    setState(() => _isListening = false);
    _speech.stop();

    // **Step 1:** Extract Actions
    Map<String, String> extractedActions = await NLPService().extractActions(_text);

    // **Step 2:** Store in Database
    await DatabaseService().insertAction(
      extractedActions['task']!,
      "task",
      extractedActions['date']!,
    );

    // **Step 3:** Update UI
    setState(() {
      _extractedTask = extractedActions['task']!;
      _extractedDate = extractedActions['date']!;
      _extractedTime = extractedActions['time']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voice-to-Action App")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Speech to Text:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(_text, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              SizedBox(height: 20),
              Text(
                "Extracted Task: $_extractedTask",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              Text(
                "Extracted Date: $_extractedDate",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              Text(
                "Extracted Time: $_extractedTime",
                style: TextStyle(fontSize: 18, color: Colors.orange),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isListening ? _stopListening : _startListening,
                child: Text(_isListening ? "Stop Recording" : "Start Recording"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
