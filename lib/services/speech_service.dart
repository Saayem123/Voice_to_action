import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _transcribedText = "";

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  void startListening(Function(String) onResult) async {
    _isListening = true;
    _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );
  }

  void stopListening() {
    _isListening = false;
    _speech.stop();
  }
}
