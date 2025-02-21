import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/nlp_service.dart';
import '../services/action_service.dart';
import 'action_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechService _speechService = SpeechService();
  final NLPService _nlpService = NLPService();
  final ActionService _actionService = ActionService();

  String _spokenText = "Tap mic and start speaking...";
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speechService.initSpeech();
  }

  void _startListening() {
    _speechService.startListening((text) {
      setState(() {
        _spokenText = text;
      });
    });
  }

  void _stopListening() async {
    _speechService.stopListening();
    var extractedActions = await _nlpService.extractActions(_spokenText);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionScreen(extractedActions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voice-to-Action")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_spokenText, style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _startListening,
                child: Icon(Icons.mic),
              ),
              SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _stopListening,
                child: Icon(Icons.stop),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
