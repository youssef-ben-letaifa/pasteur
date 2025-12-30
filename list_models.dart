import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const apiKey = 'AIzaSyC24zL3GQQNENiwVm_-yE73zRtGinGP_fc';
  const endpoint = 'https://generativelanguage.googleapis.com/v1beta/models';

  print('Listing Gemini Models...');
  final url = Uri.parse('$endpoint?key=$apiKey');

  try {
    final response = await http.get(url);

    print('Response Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final models = data['models'] as List;
      for (var model in models) {
        print('Model: ${model['name']}');
        print('Supported Methods: ${model['supportedGenerationMethods']}');
        print('---');
      }
    } else {
      print('Failed: ${response.body}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
