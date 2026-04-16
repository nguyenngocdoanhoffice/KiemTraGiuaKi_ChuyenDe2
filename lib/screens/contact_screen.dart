import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liên hệ')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: newsapp@example.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text('Điện thoại: +84 123 456 789', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
