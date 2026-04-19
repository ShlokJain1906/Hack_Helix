enum CognitiveState { LOW, MEDIUM, HIGH }
enum ProtocolStepType { info, action }
enum ActionType { call_emergency, send_location, open_map, none }

class CognitiveSignals {
  final bool urgencyWords;
  final bool repetition;
  final bool fragmentation;

  CognitiveSignals({
    required this.urgencyWords,
    required this.repetition,
    required this.fragmentation,
  });
}

class ParserResult {
  final List<String> symptoms;
  final List<String> possibleIntents;
  final Map<String, double> confidence;
  final CognitiveSignals cognitiveSignals;

  ParserResult({
    required this.symptoms,
    required this.possibleIntents,
    required this.confidence,
    required this.cognitiveSignals,
  });
}

class ProtocolStep {
  final String text;
  final ProtocolStepType type;
  final ActionType actionType;

  ProtocolStep({
    required this.text,
    this.type = ProtocolStepType.info,
    this.actionType = ActionType.none,
  });
}

class ProtocolDefinition {
  final String name;
  final String source;
  final List<ProtocolStep> steps;

  ProtocolDefinition({
    required this.name,
    required this.source,
    required this.steps,
  });
}

class TriageState {
  final String intent;
  final bool isAmbiguous;
  final String? triageQuestion;

  TriageState({
    required this.intent,
    this.isAmbiguous = false,
    this.triageQuestion,
  });
}

class EngineUIState {
  final CognitiveState mode;
  final bool voiceEnabled;
  final bool triageActive;

  EngineUIState({
    required this.mode,
    this.voiceEnabled = false,
    this.triageActive = false,
  });
}

class EngineState {
  final String intent;
  final double confidence;
  final CognitiveState cognitiveState;
  final ProtocolDefinition? protocol;
  final EngineUIState ui;

  EngineState({
    required this.intent,
    required this.confidence,
    required this.cognitiveState,
    this.protocol,
    required this.ui,
  });
}
