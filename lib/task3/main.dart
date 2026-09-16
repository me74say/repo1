import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() {
  // runApp places the root widget into Flutter's widget tree.
  runApp(const MiniMarketApp());
}

/// Root of the Task 3 Mini Market application.
class MiniMarketApp extends StatelessWidget {
  const MiniMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      // HomePage is the first route. Other screens are pushed with
      // Navigator.push(), following the imperative-navigation lesson.
      home: const HomePage(),
    );
  }
}
