import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invento_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class RasaService {
  // Use '10.0.2.2' for Android Emulator, 'localhost' for Web/iOS Simulator
  final String _rasaServerUrl = "http://localhost:5005/webhooks/rest/webhook";
  final AuthService _authService = AuthService();

  Future<String> _getSenderId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    return userId?.toString() ?? 'guest_user'; 
  }

  Future<List<ChatMessage>> sendMessage(String text, String languageCode) async {
    try {
      final senderId = await _getSenderId();
      final token = await _authService.getToken();

      final response = await http.post(
        Uri.parse(_rasaServerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender': senderId,
          'message': text,
          'metadata': {
            'language': languageCode,
            'jwt_token': token,
          }
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        
        return responseData.map((messageData) {
          List<String>? suggestions;
          if (messageData['buttons'] != null) {
            suggestions = (messageData['buttons'] as List)
                .map<String>((button) => button['title'] as String)
                .toList();
          }
          
          return ChatMessage(
            text: messageData['text'] ?? '',
            sender: 'bot',
            suggestions: suggestions,
          );
        }).toList();
      } else {
        return [ChatMessage(text: "Error: Could not connect to the assistant.", sender: 'bot')];
      }
    } catch (e) {
      print("Error sending message to Rasa: $e");
      return [ChatMessage(text: "Error: Failed to send message. Please check your connection.", sender: 'bot')];
    }
  }
}