import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/chat_message.dart';
import '../models/user_model.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  // Send message to Gemini and get response
  Future<String> sendMessage({
    required String message,
    UserModel? user,
    List<ChatMessage>? conversationHistory,
  }) async {
    try {
      // Build context from user profile and conversation history
      final context = _buildContext(user, conversationHistory);

      // Prepare the request
      final url = Uri.parse(AppConstants.geminiModelEndpoint);

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': context + message},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 2048,
        },
      };

      final response = await http.post(
        Uri.parse('${url.toString()}?key=${AppConstants.geminiApiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            return candidate['content']['parts'][0]['text'] ??
                'I apologize, but I could not generate a response.';
          }
        }

        return 'I apologize, but I could not generate a response.';
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get response from Gemini: ${e.toString()}');
    }
  }

  // Analyze symptoms and recommend doctors' specialties
  Future<Map<String, dynamic>> analyzeSymptoms({
    required String symptoms,
    UserModel? user,
  }) async {
    try {
      final context = user != null ? _buildUserMedicalContext(user) : '';

      final prompt =
          '''$context

Based on the following symptoms and user information, provide:
1. A brief analysis of the symptoms
2. Recommended medical specialties to consult
3. Urgency level (low, moderate, high, emergency)
4. General advice

Symptoms: $symptoms

Respond in JSON format:
{
  "analysis": "Brief analysis",
  "specialties": ["specialty1", "specialty2"],
  "urgency": "moderate",
  "advice": "General advice",
  "location_keywords": ["keywords to search for location-specific doctors"]
}''';

      final response = await sendMessage(message: prompt);

      // Try to parse JSON from response
      try {
        // Extract JSON from response (it might be wrapped in markdown code blocks)
        String jsonString = response;
        if (response.contains('```json')) {
          final startIndex = response.indexOf('```json') + 7;
          final endIndex = response.lastIndexOf('```');
          if (startIndex > 6 && endIndex > startIndex) {
            jsonString = response.substring(startIndex, endIndex).trim();
          }
        } else if (response.contains('```')) {
          final startIndex = response.indexOf('```') + 3;
          final endIndex = response.lastIndexOf('```');
          if (startIndex > 2 && endIndex > startIndex) {
            jsonString = response.substring(startIndex, endIndex).trim();
          }
        }

        final analysisData = jsonDecode(jsonString);
        return analysisData;
      } catch (e) {
        // If JSON parsing fails, return a formatted response
        return {
          'analysis': response,
          'specialties': ['General Practitioner'],
          'urgency': 'moderate',
          'advice':
              'Please consult with a healthcare professional for proper diagnosis.',
          'location_keywords': [],
        };
      }
    } catch (e) {
      throw Exception('Failed to analyze symptoms: ${e.toString()}');
    }
  }

  // Build context from user profile
  String _buildContext(UserModel? user, List<ChatMessage>? history) {
    final buffer = StringBuffer();

    buffer.writeln(
      'You are a medical assistant AI helping patients in Tunisia.',
    );
    buffer.writeln(
      'Provide helpful, accurate medical information while emphasizing',
    );
    buffer.writeln(
      'that users should consult healthcare professionals for diagnosis.',
    );
    buffer.writeln('Be empathetic, clear, and professional.');
    buffer.writeln(
      'Always respond in English or French based on the user\'s language.',
    );
    buffer.writeln();

    if (user != null) {
      buffer.writeln('Patient Information:');
      buffer.writeln('Name: ${user.name}');
      if (user.age != null) {
        buffer.writeln('Age: ${user.age}');
      }
      if (user.gender != null) {
        buffer.writeln('Gender: ${user.gender}');
      }
      if (user.allergies != null && user.allergies!.isNotEmpty) {
        buffer.writeln('Allergies: ${user.allergies!.join(", ")}');
      }
      if (user.chronicConditions != null &&
          user.chronicConditions!.isNotEmpty) {
        buffer.writeln(
          'Chronic Conditions: ${user.chronicConditions!.join(", ")}',
        );
      }
      if (user.currentMedications != null &&
          user.currentMedications!.isNotEmpty) {
        buffer.writeln(
          'Current Medications: ${user.currentMedications!.join(", ")}',
        );
      }
      buffer.writeln();
    }

    if (history != null && history.isNotEmpty) {
      buffer.writeln('Previous conversation context:');
      // Include last 5 messages for context
      final recentHistory = history.length > 5
          ? history.sublist(history.length - 5)
          : history;

      for (var msg in recentHistory) {
        final role = msg.isUser ? 'User' : 'Assistant';
        buffer.writeln('$role: ${msg.content}');
      }
      buffer.writeln();
    }

    buffer.writeln('User message: ');
    return buffer.toString();
  }

  String _buildUserMedicalContext(UserModel user) {
    final buffer = StringBuffer();
    buffer.writeln('Patient Medical Profile:');
    buffer.writeln('Name: ${user.name}');
    if (user.age != null) buffer.writeln('Age: ${user.age} years');
    if (user.gender != null) buffer.writeln('Gender: ${user.gender}');
    if (user.bloodType != null) buffer.writeln('Blood Type: ${user.bloodType}');
    if (user.height != null) buffer.writeln('Height: ${user.height} cm');
    if (user.weight != null) buffer.writeln('Weight: ${user.weight} kg');

    if (user.allergies != null && user.allergies!.isNotEmpty) {
      buffer.writeln('Allergies: ${user.allergies!.join(", ")}');
    }
    if (user.chronicConditions != null && user.chronicConditions!.isNotEmpty) {
      buffer.writeln(
        'Chronic Conditions: ${user.chronicConditions!.join(", ")}',
      );
    }
    if (user.currentMedications != null &&
        user.currentMedications!.isNotEmpty) {
      buffer.writeln(
        'Current Medications: ${user.currentMedications!.join(", ")}',
      );
    }

    if (user.city != null) {
      buffer.writeln('Location: ${user.city}');
    }
    buffer.writeln();

    return buffer.toString();
  }
}

// Extension to get age from user model
extension UserModelExtension on UserModel {
  int? get age {
    if (dateOfBirth == null) return null;
    final today = DateTime.now();
    var age = today.year - dateOfBirth!.year;
    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month && today.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
}
