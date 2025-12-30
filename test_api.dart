import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const apiKey = 'XXXXXXXXXXXXXXXXXXXXXXX  USE YOUR API KEY ';
  const endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  print('Testing Gemini API...');
  print('Endpoint: $endpoint');

  final url = Uri.parse('$endpoint?key=$apiKey');

  final requestBody = {
    'contents': [
      {
        'parts': [
          {'text': 'Hello, are you working?'},
        ],
      },
    ],
    'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 100},
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('Success!');
    } else {
      print('Failed!');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
