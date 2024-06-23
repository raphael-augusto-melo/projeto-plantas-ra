import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;

  GeminiService() : apiKey = dotenv.env['GEMINI_API_KEY']!;

  Future<String> analyzeImage(File imageFile) async {
    final model = GenerativeModel(model: "gemini-1.5-pro", apiKey: apiKey);
    final bytes = await imageFile.readAsBytes();

    try {
      final response = await model.generateContent([
        Content.text("""Você é um panda especialista em jardinagem, e sua missão é dizer qual planta está na imagem, fornecer as informações básicas sobre a planta e dar dicas para cuidar bem dela. Você mora no Brasil. Seja criativo nas respostas
Quando for falar o nome da planta, sempre opte por usar o nome popular também. Identifique se a planta está saudável ou não.
Responda as orientações sobre cuidados em tópicos."""),
        Content.data("image/png", bytes),
      ]);

      return response.text ?? "No response";
    } catch (e) {
      throw Exception('Erro ao chamar a API do Gemini: $e');
    }
  }
}
