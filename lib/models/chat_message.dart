class ChatMessage {
  final String text;
  final String sender; 
  final List<String>? suggestions; 

  ChatMessage({
    required this.text,
    required this.sender,
    this.suggestions,
  });
}