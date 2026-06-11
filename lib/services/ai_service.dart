import 'package:http/http.dart' as http;
import 'dart:convert';

class AIService {
  static final AIService _instance = AIService._internal();

  // Replace with your AI API endpoint (Gemini, OpenAI, etc)
  static const String _aiApiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  AIService._internal();

  factory AIService() {
    return _instance;
  }

  /// Generate romantic letter using AI
  /// Using Google Gemini API (you need to add your API key to env.txt)
  Future<String> generateRomanticLetter({
    required String creatorName,
    required String recipientName,
    required String occasion, // e.g., "Aniversário", "Dia dos Namorados"
    String? customTheme,
  }) async {
    try {
      final apiKey = _getApiKey(); // Get from env

      final prompt = '''
Crie uma carta romântica e personalizada com as seguintes informações:
- De: $creatorName
- Para: $recipientName
- Ocasião: $occasion
${customTheme != null ? '- Tema especial: $customTheme' : ''}

Requisitos:
- Extensão: 200-300 palavras
- Tom: Romântico, sincero e tocante
- Idioma: Português
- Sem emojis
- Finalize com uma frase marcante

Gere apenas a carta, sem explicações.
      ''';

      final response = await http.post(
        Uri.parse('$_aiApiEndpoint?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('AI request timeout');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final letter =
            data['candidates'][0]['content']['parts'][0]['text'] ?? '';
        return letter;
      } else {
        throw Exception('AI API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to generate letter: $e');
    }
  }

  /// Generate poem based on emotion/theme
  Future<String> generatePoem({
    required String theme, // "love", "passion", "eternal", etc
    String? style, // "modern" or "classic"
  }) async {
    try {
      final apiKey = _getApiKey();

      final prompt = '''
Crie um poema romântico com as seguintes características:
- Tema: $theme
- Estilo: ${style ?? 'moderno'}
- Extensão: 16-24 linhas
- Idioma: Português
- Rima: ABAB ou livre

Gere apenas o poema, sem títulos ou explicações.
      ''';

      final response = await http.post(
        Uri.parse('$_aiApiEndpoint?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('AI request timeout');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final poem =
            data['candidates'][0]['content']['parts'][0]['text'] ?? '';
        return poem;
      } else {
        throw Exception('AI API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to generate poem: $e');
    }
  }

  /// Get API key from environment
  String _getApiKey() {
    // Get from your env loader
    // return EnvLoader.get('GEMINI_API_KEY') ?? '';
    return ''; // TODO: Configure in env
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => 'TimeoutException: $message';
}
