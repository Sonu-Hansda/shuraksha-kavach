import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is AuthInitial) {
          Navigator.of(context).pushReplacementNamed('/landing');
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              // Image.asset(
              //   'assets/images/logo.png',
              //   width: 150,
              //   height: 150,
              // ),
              const SizedBox(height: 24),
              // App Name
              const Text(
                'Shurakhsa Kavach',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
