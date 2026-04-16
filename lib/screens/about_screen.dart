import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giới thiệu')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Đây là ứng dụng tin tức cá nhân được xây dựng bằng Flutter.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
