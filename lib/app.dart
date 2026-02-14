import 'package:flutter/material.dart';
import 'screens/root_screen.dart';
import 'theme/app_theme.dart';

class HymnApp extends StatelessWidget {
  const HymnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hymn',
      theme: AppTheme.light(),
      home: const RootScreen(),
    );
  }
}
