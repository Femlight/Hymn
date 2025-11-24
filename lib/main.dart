/*
OpenLeaves Project.
Super cool Hymn book project demo.
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_leaves/screens/home_screen.dart';
import 'package:open_leaves/screens/settings_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  void _updateTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _openSettings() {
    _navKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          themeMode: _themeMode,
          onThemeChanged: _updateTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseText = const TextTheme(
      bodyMedium: TextStyle(fontFamily: 'Nunito'),
      bodyLarge: TextStyle(fontFamily: 'Nunito'),
      titleLarge: TextStyle(fontFamily: 'Nunito'),
    );

    final light = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F766E),
        brightness: Brightness.light,
      ),
      textTheme: baseText,
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      visualDensity: Platform.isLinux
          ? VisualDensity.comfortable
          : VisualDensity.adaptivePlatformDensity,
    );

    final dark = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F766E),
        brightness: Brightness.dark,
      ),
      textTheme: baseText,
      scaffoldBackgroundColor: const Color(0xFF0B0F12),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      visualDensity: Platform.isLinux
          ? VisualDensity.comfortable
          : VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      title: "F.E.A.C. Hymns",
      navigatorKey: _navKey,
      themeMode: _themeMode,
      theme: light,
      darkTheme: dark,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        onOpenSettings: _openSettings,
      ),
    );
  }
}
