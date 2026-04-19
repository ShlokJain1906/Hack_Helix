import 'ml_severity_model.dart';

class OfflineInference {
  /// Analyzes the emergency description and returns a severity score (0 to 3).
  /// 0 = Low, 1 = Medium, 2 = High, 3 = Critical
  static int analyzeSeverity(String text) {
    if (text.isEmpty) return 0;

    // 1. Tokenize text (simple lowercasing and punctuation removal)
    final cleanedText = text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    final tokens = cleanedText.split(RegExp(r'\s+'));

    // 2. Vectorize using the model's vocabulary
    final features = List<double>.filled(MLModelData.vocabulary.length, 0.0);
    for (int i = 0; i < MLModelData.vocabulary.length; i++) {
      if (tokens.contains(MLModelData.vocabulary[i])) {
        features[i] = 1.0;
      }
    }

    // 3. Run through Random Forest
    return MLModelData.predictSeverity(features);
  }
}
