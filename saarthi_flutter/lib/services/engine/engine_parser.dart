import '../../models/core_engine_models.dart';

class EngineParser {
  /// Mocks the Small Language Model (SLM) parsing step.
  /// In a real scenario, this would send the input to the local ONNX/TFLite model
  /// and return a structured JSON which is then mapped to ParserResult.
  static ParserResult parseInput(String input) {
    final lowerInput = input.toLowerCase();

    // Scenario 1: “He’s not breathing help help”
    if (lowerInput.contains('breathing') && lowerInput.contains('help')) {
      return ParserResult(
        symptoms: ['breathing_issue', 'unconscious'],
        possibleIntents: ['cardiac_arrest', 'choking'],
        confidence: {'cardiac_arrest': 0.85, 'choking': 0.40},
        cognitiveSignals: CognitiveSignals(
          urgencyWords: true, // "help"
          repetition: true,   // "help help"
          fragmentation: true, // "He's not breathing help help"
        ),
      );
    }

    // Scenario 2: “There’s a cut on his arm”
    if (lowerInput.contains('cut') || lowerInput.contains('bleed')) {
      return ParserResult(
        symptoms: ['bleeding'],
        possibleIntents: ['severe_bleeding', 'minor_cut'],
        confidence: {'severe_bleeding': 0.50, 'minor_cut': 0.60},
        cognitiveSignals: CognitiveSignals(
          urgencyWords: false,
          repetition: false,
          fragmentation: false,
        ),
      );
    }

    // Scenario 3: “He collapsed and gasping”
    if (lowerInput.contains('collapse') || lowerInput.contains('gasp')) {
      return ParserResult(
        symptoms: ['unconscious', 'breathing_issue'],
        possibleIntents: ['cardiac_arrest', 'choking'],
        confidence: {'cardiac_arrest': 0.70, 'choking': 0.65},
        cognitiveSignals: CognitiveSignals(
          urgencyWords: false,
          repetition: false,
          fragmentation: true,
        ),
      );
    }

    // Scenario 4: Unknown input
    return ParserResult(
      symptoms: [],
      possibleIntents: ['unknown'],
      confidence: {'unknown': 0.99},
      cognitiveSignals: CognitiveSignals(
        urgencyWords: false,
        repetition: false,
        fragmentation: false,
      ),
    );
  }
}
