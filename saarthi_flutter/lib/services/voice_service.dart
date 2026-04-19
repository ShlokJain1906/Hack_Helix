import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class VoiceService extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  double _level = 0.0;

  bool get isListening => _isListening;
  String get lastWords => _lastWords;
  double get level => _level;

  Future<bool> initSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (kDebugMode) print('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
            notifyListeners();
          }
        },
        onError: (error) {
          if (kDebugMode) print('Speech error: $error');
          _isListening = false;
          notifyListeners();
        },
      );
      return available;
    } catch (e) {
      if (kDebugMode) print('Speech init exception: $e');
      return false;
    }
  }

  Future<void> startListening(Function(String) onResult) async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) return;
    }

    _lastWords = '';
    _isListening = true;
    notifyListeners();

    await _speech.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        if (result.finalResult) {
          _isListening = false;
          onResult(_lastWords);
        }
        notifyListeners();
      },
      onSoundLevelChange: (level) {
        _level = level;
        notifyListeners();
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
    notifyListeners();
  }
}
