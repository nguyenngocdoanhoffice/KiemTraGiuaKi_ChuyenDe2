import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'This app does not collect user data.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
