import 'package:flutter/foundation.dart';
import '../models/emergency_protocol.dart';
import 'emergency_mock_data.dart';
import 'offline_inference.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String styleClass;

  ChatMessage({required this.text, required this.isUser, this.styleClass = ''});
}

class EmergencyService extends ChangeNotifier {
  EmergencyProtocol? currentProtocol;
  List<ChatMessage> chatMessages = [];
  bool isTyping = false;
  int currentVoiceStep = 0;
  bool isStressHigh = false;
  int currentSeverity = 0;
  bool requiresCriticalConfirmation = false;

  void startEmergency(String typeId) {
    currentProtocol = mockEmergencyData[typeId] ?? mockEmergencyData['custom']!;
    chatMessages.clear();
    currentVoiceStep = 0;
    isStressHigh = false;
    currentSeverity = 0;
    requiresCriticalConfirmation = false;
    isTyping = false;
    notifyListeners();
    
    _playGreetingSequence();
  }

  void _playGreetingSequence() async {
    await Future.delayed(const Duration(milliseconds: 120));
    addAiMessage('What\'s the emergency? I\'m here to help immediately.');
    
    if (currentProtocol!.initialMsg.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 900));
      addUserMessage(currentProtocol!.initialMsg);
      await _playAIResponses();
    }
  }

  Future<void> _playAIResponses() async {
    if (currentProtocol == null) return;
    for (int i = 0; i < currentProtocol!.responses.length; i++) {
      setTyping(true);
      await Future.delayed(const Duration(milliseconds: 1100)); // Simulate AI thinking
      setTyping(false);
      addAiMessage(currentProtocol!.responses[i].text, styleClass: currentProtocol!.responses[i].styleClass);
    }
  }

  void submitUserMessage(String text) async {
    if (text.isEmpty) return;
    addUserMessage(text);
    
    // Evaluate severity using the offline ML model
    currentSeverity = OfflineInference.analyzeSeverity(text);
    if (kDebugMode) {
      print('--- Offline ML Prediction ---');
      print('Input: "$text"');
      print('Predicted Severity Score: $currentSeverity / 3');
      print('-----------------------------');
    }

    // Safety Override: Deterministic bumping for high-stress keywords
    final lo = text.toLowerCase();
    final highStressWords = ['major', 'severe', 'deep', 'heavy', 'critical', 'danger', 'bleeding'];
    if (highStressWords.any((w) => lo.contains(w))) {
      if (currentSeverity < 2) {
        currentSeverity = 2; // Force at least Level 2 (High) for these words
        if (kDebugMode) print('Severity bumped to 2 due to high-stress keyword.');
      }
    }
    
    // If severity is High or Critical, instantly show the stress banner
    if (currentSeverity >= 2) {
      isStressHigh = true;
    }
    // If Critical, ask for confirmation
    if (currentSeverity == 3) {
      requiresCriticalConfirmation = true;
    }
    notifyListeners();
    
    // Fallback classification logic (keyword → emergency type)
    const classificationMap = {
      'heart': 'heart', 'chest': 'heart', 'cardiac': 'heart',
      'chok': 'breathing', 'breath': 'breathing', 'asthma': 'breathing',
      'bleed': 'bleeding', 'cut': 'bleeding', 'wound': 'bleeding',
      'uncons': 'unconscious', 'collaps': 'unconscious', 'faint': 'unconscious', 'respond': 'unconscious',
      'accident': 'accident', 'crash': 'accident', 'road': 'accident',
      'fire': 'fire', 'smoke': 'fire', 'burn': 'fire',
      'attack': 'crime', 'rob': 'crime', 'crime': 'crime', 'threat': 'crime',
      'headache': 'minor_ailment', 'stomach': 'minor_ailment', 'scratch': 'minor_ailment', 'papercut': 'minor_ailment',
    };
    String newType = currentProtocol?.id ?? 'custom';
    
    if (currentSeverity == 0) {
      // For low severity, prioritize the Minor Ailment protocol
      if (lo.contains('headache') || lo.contains('scratch') || lo.contains('stomach') || lo.contains('minor')) {
        newType = 'minor_ailment';
      } else {
        // Fallback search in map
        for (final entry in classificationMap.entries) {
          if (lo.contains(entry.key)) {
            newType = entry.value;
            break;
          }
        }
      }
    } else {
      // For higher severity, look for serious protocols and ignore "minor" matches
      for (final entry in classificationMap.entries) {
        if (lo.contains(entry.key) && entry.value != 'minor_ailment') {
          newType = entry.value;
          break;
        }
      }
    }
    
    if (newType != currentProtocol?.id) {
       currentProtocol = mockEmergencyData[newType];
       notifyListeners();
    }
    
    await _playAIResponses();
  }

  void addUserMessage(String text) {
    chatMessages.add(ChatMessage(text: text, isUser: true));
    notifyListeners();
  }

  void addAiMessage(String text, {String styleClass = ''}) {
    chatMessages.add(ChatMessage(text: text, isUser: false, styleClass: styleClass));
    notifyListeners();
  }

  void setTyping(bool typing) {
    isTyping = typing;
    notifyListeners();
  }

  void clearCriticalConfirmation() {
    requiresCriticalConfirmation = false;
    notifyListeners();
  }

  void nextVoiceStep() {
    if (currentProtocol != null && currentProtocol!.voiceSteps.isNotEmpty) {
      currentVoiceStep = (currentVoiceStep + 1) % currentProtocol!.voiceSteps.length;
      notifyListeners();
    }
  }

  String get currentVoiceInstruction {
    if (currentProtocol != null && currentProtocol!.voiceSteps.isNotEmpty) {
      return currentProtocol!.voiceSteps[currentVoiceStep];
    }
    return "Stay calm. I'm listening.";
  }
}
