import 'package:flutter/material.dart';
import 'package:shurakhsa_kavach/core/theme/app_theme.dart';
import 'package:shurakhsa_kavach/features/auth/presentation/pages/landing_page.dart';
import 'package:shurakhsa_kavach/features/auth/presentation/pages/login_page.dart';
import 'package:shurakhsa_kavach/features/auth/presentation/pages/register_page.dart';
import 'package:shurakhsa_kavach/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shurakhsa Kavach',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
