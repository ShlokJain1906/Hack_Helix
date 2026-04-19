import 'lib/services/offline_inference.dart';

void main() {
  final testCases = [
    "minor scratch",
    "major scratch",
    "major headache"
  ];

  for (var text in testCases) {
    final severity = OfflineInference.analyzeSeverity(text);
    print('Input: "$text" -> Predicted Severity: $severity');
  }
}
