import 'package:flutter/foundation.dart';
import '../../models/core_engine_models.dart';
import 'engine_parser.dart';
import 'engine_triage.dart';

class CoreEngineService extends ChangeNotifier {
  EngineState? currentState;
  String? currentInput;
  ParserResult? _lastParsedResult;

  void processInput(String input) {
    currentInput = input;
    
    // Step 1: Parse
    _lastParsedResult = EngineParser.parseInput(input);
    
    // Step 2: Cognitive Overload
    final cognitiveState = EngineTriage.calculateCognitiveState(_lastParsedResult!.cognitiveSignals);
    
    // Step 3: Triage
    final triageState = EngineTriage.evaluateTriage(_lastParsedResult!);

    // Step 4 & 5 & 6: Protocol & UI Mode
    if (triageState.isAmbiguous) {
      // Pause for Triage
      currentState = EngineState(
        intent: triageState.intent,
        confidence: 0.0, // Needs confirmation
        cognitiveState: cognitiveState,
        ui: EngineUIState(
          mode: cognitiveState,
          triageActive: true,
          voiceEnabled: false,
        ),
      );
      // We temporarily store the question in protocol name for UI to read
      currentState = EngineState(
        intent: triageState.intent,
        confidence: 0.0,
        cognitiveState: cognitiveState,
        protocol: ProtocolDefinition(
          name: triageState.triageQuestion ?? 'Please clarify',
          source: 'System',
          steps: [],
        ),
        ui: EngineUIState(
          mode: cognitiveState,
          triageActive: true,
          voiceEnabled: false,
        ),
      );
    } else {
      // Direct Protocol Load
      final protocol = EngineTriage.loadProtocol(triageState.intent);
      
      currentState = EngineState(
        intent: triageState.intent,
        confidence: _lastParsedResult!.confidence[triageState.intent] ?? 1.0,
        cognitiveState: cognitiveState,
        protocol: protocol,
        ui: EngineUIState(
          mode: cognitiveState,
          voiceEnabled: cognitiveState == CognitiveState.HIGH,
          triageActive: false,
        ),
      );
    }
    
    notifyListeners();
  }

  void answerTriage(bool answer) {
    if (currentState == null || !currentState!.ui.triageActive || _lastParsedResult == null) return;
    
    // If the user answers Yes to the ambiguity question, we lock into the highest priority intent
    // If No, we would theoretically load the secondary intent. 
    // For this demonstration, if Yes -> load protocol for the top intent.
    // If No -> Fallback.
    
    final intents = _lastParsedResult!.possibleIntents;
    String finalIntent = 'unknown';

    if (answer && intents.isNotEmpty) {
      // For simplicity, lock the first (highest priority) intent that triggered the question
      // In a robust implementation, the triage question is directly tied to a specific intent check.
      // E.g., if we asked about cardiac arrest, we assume Yes means cardiac arrest.
      // Since `_lastParsedResult` intents are not sorted, let's just grab the first from priority.
      final sortedIntents = intents.toList(); // Note: we'd ideally store sortedIntents in state
      sortedIntents.sort((a,b) => a.compareTo(b)); // Dummy sort for now
      finalIntent = sortedIntents.isNotEmpty ? sortedIntents.first : 'unknown';
      // Actually, let's re-run evaluateTriage but force the confidence to 1.0 for the intent we asked about.
      // This is a simplified mock of answering.
      if (intents.contains('severe_bleeding')) {
        finalIntent = answer ? 'severe_bleeding' : 'minor_cut';
      } else if (intents.contains('cardiac_arrest')) {
        finalIntent = answer ? 'cardiac_arrest' : 'choking';
      }
    }

    final protocol = EngineTriage.loadProtocol(finalIntent);

    currentState = EngineState(
      intent: finalIntent,
      confidence: 1.0, // Confirmed by user
      cognitiveState: currentState!.cognitiveState,
      protocol: protocol,
      ui: EngineUIState(
        mode: currentState!.cognitiveState,
        voiceEnabled: currentState!.cognitiveState == CognitiveState.HIGH,
        triageActive: false,
      ),
    );

    notifyListeners();
  }
}
