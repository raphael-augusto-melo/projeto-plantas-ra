import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  final String apiKey;
  final String model = 'gemini-1.5-pro';

  GeminiService(this.apiKey);

  Future<String> analyzeImage(File imageFile) async {
    final uri = Uri.parse('https://ai.googleapis.com/v1/images:analyze?key=$apiKey');
    final bytes = await imageFile.readAsBytes();

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'model': model,
        'image': base64Encode(bytes),
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result']['description'] ?? 'No description found';
    } else {
      throw Exception('Failed to analyze image');
    }
  }
}
