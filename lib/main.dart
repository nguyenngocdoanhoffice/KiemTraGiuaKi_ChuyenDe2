import 'package:flutter/material.dart';
import 'package:my_app/providers/news_provider.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider(apiService: ApiService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal News App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
