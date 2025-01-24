import 'package:flutter/material.dart';
import 'package:mailchat/mail/send_email.dart'; // Import the SendEmail class

class ChatScreen extends StatelessWidget {
  final String contactName;
  final String contactEmail;
  final TextEditingController _messageController = TextEditingController();

  ChatScreen({super.key, required this.contactName, required this.contactEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chat with $contactName'),
            Text(
              contactEmail,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 0, // Replace with the actual message count
              itemBuilder: (context, index) {
                // Replace with the actual message widget
                return ListTile(
                  title: Text('Message $index'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      final sendEmail = SendEmail();
                      try {
                        await sendEmail.sendEmail(
                          contactEmail,
                          'New message from $contactName',
                          _messageController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email sent successfully')),
                        );
                        _messageController.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to send email: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}