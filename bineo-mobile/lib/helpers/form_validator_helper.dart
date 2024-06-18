import 'package:dart_levenshtein/dart_levenshtein.dart';

class FormValidatorHelper {
  static Future<bool> levenshtein(
      String originalValue, String newValue, double tolerance) async {
    final toleratedDistance = (tolerance * originalValue.length);
    final distance = await originalValue.levenshteinDistance(newValue);
    return distance <= toleratedDistance;
  }
}
