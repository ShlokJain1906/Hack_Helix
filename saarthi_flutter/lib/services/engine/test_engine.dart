import 'core_engine_service.dart';
import '../../models/core_engine_models.dart';

void main() {
  final service = CoreEngineService();

  void printState(String label) {
    print('\n=== $label ===');
    if (service.currentState == null) {
      print('State is null');
      return;
    }
    
    final state = service.currentState!;
    print('Intent: ${state.intent} (Confidence: ${state.confidence})');
    print('Cognitive State: ${state.cognitiveState.name}');
    
    if (state.ui.triageActive) {
      print('>>> TRIAGE PAUSE <<<');
      print('Question: ${state.protocol?.name}');
    } else {
      print('Protocol: ${state.protocol?.name} (Source: ${state.protocol?.source})');
      print('UI Mode: ${state.ui.mode.name} | Voice: ${state.ui.voiceEnabled}');
      print('Steps:');
      for (var step in state.protocol!.steps) {
        if (step.type == ProtocolStepType.action) {
          print('  [ACTION: ${step.actionType.name}] ${step.text}');
        } else {
          print('  - ${step.text}');
        }
      }
    }
  }

  // Scenario 1
  service.processInput("He's not breathing help help");
  printState('SCENARIO 1 (High Urgency)');

  // Scenario 2
  service.processInput("There's a cut on his arm");
  printState('SCENARIO 2 (Ambiguity / Triage)');
  
  print('\n[User answers YES to Triage]');
  service.answerTriage(true);
  printState('SCENARIO 2 (Post-Triage YES)');

  // Scenario 3
  service.processInput("He collapsed and gasping");
  printState('SCENARIO 3 (Ambiguity / Triage)');

  // Scenario 4
  service.processInput("The sky is blue");
  printState('SCENARIO 4 (Unknown / Fallback)');
}
