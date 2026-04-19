import '../../models/core_engine_models.dart';

class EngineTriage {
  static const double CONFIDENCE_THRESHOLD = 0.80;

  // Step 2: Cognitive Overload Scoring
  static CognitiveState calculateCognitiveState(CognitiveSignals signals) {
    int score = 0;
    if (signals.urgencyWords) score++;
    if (signals.repetition) score++;
    if (signals.fragmentation) score++;

    if (score == 0) return CognitiveState.LOW;
    if (score <= 2) return CognitiveState.MEDIUM;
    return CognitiveState.HIGH;
  }

  // Step 3: Triage Engine
  static TriageState evaluateTriage(ParserResult parsedData) {
    if (parsedData.possibleIntents.isEmpty || parsedData.possibleIntents.contains('unknown')) {
      return TriageState(intent: 'unknown');
    }

    // Sort intents by predefined priority (mocked priority logic)
    final sortedIntents = _sortByPriority(parsedData.possibleIntents);
    final topIntent = sortedIntents.first;
    final topConfidence = parsedData.confidence[topIntent] ?? 0.0;

    if (topConfidence >= CONFIDENCE_THRESHOLD) {
      return TriageState(intent: topIntent);
    } else {
      // Ambiguity triggers a question
      return TriageState(
        intent: 'pending_triage',
        isAmbiguous: true,
        triageQuestion: _getQuestionForIntent(topIntent),
      );
    }
  }

  static List<String> _sortByPriority(List<String> intents) {
    // Priority: cardiac_arrest > choking > severe_bleeding > others
    const priorities = {
      'cardiac_arrest': 1,
      'choking': 2,
      'severe_bleeding': 3,
      'breathing_issue': 4,
    };

    final sorted = List<String>.from(intents);
    sorted.sort((a, b) {
      final pA = priorities[a] ?? 99;
      final pB = priorities[b] ?? 99;
      return pA.compareTo(pB);
    });
    return sorted;
  }

  static String _getQuestionForIntent(String intent) {
    switch (intent) {
      case 'cardiac_arrest':
        return 'Is the person unresponsive and not breathing normally?';
      case 'choking':
        return 'Is the person unable to speak or cough?';
      case 'severe_bleeding':
        return 'Is the bleeding heavy or not stopping?';
      default:
        return 'Is the condition severe or life-threatening?';
    }
  }

  // Step 4: Protocol Engine
  static ProtocolDefinition loadProtocol(String intent) {
    if (intent == 'cardiac_arrest') {
      return ProtocolDefinition(
        name: 'cardiac_arrest',
        source: 'WHO / Red Cross',
        steps: [
          ProtocolStep(
            text: 'Call Nearest Emergency Service',
            type: ProtocolStepType.action,
            actionType: ActionType.call_emergency,
          ),
          ProtocolStep(text: 'Check responsiveness'),
          ProtocolStep(text: 'Start chest compressions'),
          ProtocolStep(text: 'Push hard and fast in the center of the chest'),
        ],
      );
    }
    
    if (intent == 'severe_bleeding') {
      return ProtocolDefinition(
        name: 'severe_bleeding',
        source: 'Red Cross',
        steps: [
          ProtocolStep(
            text: 'Call Nearest Emergency Service',
            type: ProtocolStepType.action,
            actionType: ActionType.call_emergency,
          ),
          ProtocolStep(text: 'Apply direct pressure to the wound'),
          ProtocolStep(text: 'Keep the injured area elevated'),
        ],
      );
    }

    if (intent == 'minor_cut') {
      return ProtocolDefinition(
        name: 'minor_cut',
        source: 'First Aid Manual',
        steps: [
          ProtocolStep(text: 'Wash the cut with water'),
          ProtocolStep(text: 'Apply a clean bandage'),
        ],
      );
    }

    // Step 5: Fallback Protocol
    return ProtocolDefinition(
      name: 'UNIVERSAL EMERGENCY PROTOCOL',
      source: 'Saarthi Safety Fallback',
      steps: [
        ProtocolStep(
          text: 'Send Current Location to Emergency Contacts',
          type: ProtocolStepType.action,
          actionType: ActionType.send_location,
        ),
        ProtocolStep(text: 'Check responsiveness'),
        ProtocolStep(text: 'Ensure airway is clear'),
        ProtocolStep(text: 'Check breathing'),
        ProtocolStep(text: 'Stay with the person'),
      ],
    );
  }
}
