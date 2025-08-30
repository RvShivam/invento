// lib/screens/assistant_screen.dart
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/rasa_service.dart'; // Import the new service

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final RasaService _rasaService = RasaService(); // Create an instance of the service
  bool _isLoading = false; // To show a typing indicator for the bot

  @override
  void initState() {
    super.initState();
    // Initial bot message can still be hardcoded or fetched from Rasa
    _addBotMessage("Hello! I am your Invento Assistant. How can I help you today?");
  }
  
  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.insert(0, message);
    });
  }
  
  void _addBotMessage(String text, {List<String>? suggestions}) {
    _addMessage(ChatMessage(text: text, sender: 'bot', suggestions: suggestions));
  }

  // This function now handles the full conversation flow
  void _sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    // Add the user's message to the UI immediately
    _addMessage(ChatMessage(text: text, sender: 'user'));
    _controller.clear();

    // Show a loading indicator and send the message to Rasa
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the response from the Rasa service
      final botResponses = await _rasaService.sendMessage(text);
      
      // Add each response message from the bot to the UI
      for (var message in botResponses) {
        _addMessage(message);
      }
    } catch (e) {
      // Handle any errors from the service
      _addBotMessage("Sorry, something went wrong. Please try again.");
    } finally {
      // Hide the loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invento Assistant'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // This Expanded widget is the crucial part that fixes the layout.
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Show a "Bot is typing..." indicator when loading
          if (_isLoading) _buildTypingIndicator(),
          
          // Your input area will now be visible at the bottom
          _buildInputArea(),
        ],
      ),
    );
  }

  // This widget shows a simple "typing" animation for the bot
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
          const SizedBox(width: 8),
          Text(
            "Invento Assistant is typing...",
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }

  // The rest of the UI code remains largely the same
  Widget _buildInputArea() {
    // ... no changes here
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type or tap the mic to speak...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2A2D3E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () { /* TODO */ },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Icon(Icons.mic, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    // ... no changes here
     bool isUser = message.sender == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Theme.of(context).colorScheme.primary : const Color(0xFF2A2D3E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            if (message.suggestions != null && message.suggestions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: message.suggestions!.map((suggestion) {
                    return ActionChip(
                      label: Text(suggestion),
                      onPressed: () {
                        // When a suggestion is tapped, send it as a new message
                        _controller.text = suggestion;
                        _sendMessage();
                      },
                      backgroundColor: const Color(0xFF434654),
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}