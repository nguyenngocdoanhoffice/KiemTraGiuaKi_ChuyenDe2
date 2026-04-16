import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'This is a personal news app built with Flutter.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
