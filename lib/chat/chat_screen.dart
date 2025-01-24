import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String contactName;
  final String contactEmail;

  const ChatScreen({super.key, required this.contactName, required this.contactEmail});

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
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement send message logic
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