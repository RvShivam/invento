import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isConfirmed = _controller.text == 'DELETE';
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2A2D3E),
      title: const Text('Delete Account'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text(
              'This is a permanent action. All your inventory and sales data will be lost.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please type "DELETE" to confirm.',
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'DELETE',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _isConfirmed
              ? () {
                  // TODO: Call backend service to delete the account
                  Navigator.of(context).pop(); 
                  Navigator.of(context).pushReplacementNamed('/signup');
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            disabledBackgroundColor: Colors.grey[800],
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}