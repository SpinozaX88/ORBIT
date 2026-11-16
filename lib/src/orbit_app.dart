import 'package:flutter/material.dart';
import 'orbit_home.dart';

class OrbitApp extends StatelessWidget {
  const OrbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORBIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080B12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF59C8FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const OrbitHome(),
    );
  }
}
