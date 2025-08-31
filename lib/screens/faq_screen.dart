import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          _FaqTile(
            question: 'How do I add a new item?',
            answer:
                'From the Inventory screen, tap the blue plus (+) button at the bottom right to open the "Add Item" form.',
          ),
          _FaqTile(
            question: 'How do I edit an item?',
            answer:
                'First, tap on an item in the inventory list to go to its details page. From there, tap the "Edit Item" button at the bottom to open the editing form.',
          ),
          _FaqTile(
            question: 'How do I adjust the stock of an item?',
            answer:
                'Navigate to the item\'s details page from the inventory list. From there, tap the "Adjust Stock" button to open an overlay where you can add or remove units.',
          ),
          _FaqTile(
            question: 'How do I delete an item permanently?',
            answer:
                'From the item\'s details page, tap the trash can icon in the top-right corner. You will be asked to confirm the deletion. Please be aware that this action cannot be undone.',
          ),
          _FaqTile(
            question: 'How do I record a new sale?',
            answer:
                'From the Sales Management screen, tap the "Record New Sale" button. This will take you to a screen to select items and quantities, followed by a screen to add customer details and confirm the sale.',
          ),
          _FaqTile(
            question: 'How do I view the details of a past sale?',
            answer:
                'Go to the Sales & Reports hub and select "Sales Management". Tap on any transaction card in the history list to see its full details, including all items sold.',
          ),
          _FaqTile(
            question: 'How do I filter or sort my inventory?',
            answer:
                'On the Inventory screen, tap the filter icon next to the search bar. This will open an overlay where you can select various sorting and filtering options.',
          ),
          _FaqTile(
            question: 'How can I download a report?',
            answer:
                'Navigate to either the Sales Report or Low Stock Report screen. Tap the download icon in the top right corner of the app bar to save the report as a CSV file.',
          ),
          _FaqTile(
            question: 'What is the Invento Assistant?',
            answer:
                'The Invento Assistant, accessible via the microphone icon on the bottom navigation bar, allows you to use voice or text commands to quickly check stock and perform other actions.',
          ),
          _FaqTile(
            question: 'How do I change my password?',
            answer:
                'Navigate to the Settings tab and tap on "Change Password". You will be required to enter your current password before you can set a new one.',
          ),
        ],
      ),
    );
  }
}

// A reusable widget for each FAQ item
class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1F2E),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
        
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 16.0, bottom: 16.0, top: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(answer, style: const TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }
}