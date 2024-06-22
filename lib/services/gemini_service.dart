import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GeminiService(String s);

  void main() async {

    // Access your API key as an environment variable (see "Set up your API key" above)
    final apiKey = Platform.environment['AIzaSyDzFyVrF85lTHhxuSXAiABE4pukO4Vvp3Y'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    // The Gemini 1.5 models are versatile and work with most use cases
    final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
  }
}