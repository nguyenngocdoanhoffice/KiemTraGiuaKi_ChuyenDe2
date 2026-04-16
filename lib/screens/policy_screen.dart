import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chính sách')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Ứng dụng này không thu thập dữ liệu người dùng.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
