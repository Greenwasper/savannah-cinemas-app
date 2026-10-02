import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme.dart';

class SavannahApp extends StatelessWidget {
  const SavannahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savannah Cinemas',
      debugShowCheckedModeBanner: false,
      theme: SavannahTheme.dark,
      home: const LoginScreen(),
    );
  }
}
