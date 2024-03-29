import 'package:flutter/material.dart';

import 'FlashLightScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazing FlashLight',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const FlashLightScreen(),
    );
  }
}
