// lib/services/rasa_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class RasaService {
  // Replace with your Rasa server's IP address and port.
  // If running Rasa on your local machine, this will likely be your computer's IP.
  // Example for a local server: 'http://192.168.1.10:5005/webhooks/rest/webhook'
  final String _rasaServerUrl = "http://<YOUR_RASA_SERVER_IP>:5005/webhooks/rest/webhook";

  // A unique ID for the user session. In a real app, you'd generate or persist this.
  final String _senderId = "user_123";

  Future<List<ChatMessage>> sendMessage(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_rasaServerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender': _senderId,
          'message': text,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        
        // Convert the Rasa response format into our ChatMessage model
        return responseData.map((messageData) {
          // Check for suggestion buttons (quick replies in Rasa)
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
        // Handle server errors
        return [ChatMessage(text: "Error: Could not connect to the server.", sender: 'bot')];
      }
    } catch (e) {
      // Handle network or other errors
      print("Error sending message to Rasa: $e");
      return [ChatMessage(text: "Error: Failed to send message. Please check your connection.", sender: 'bot')];
    }
  }
}