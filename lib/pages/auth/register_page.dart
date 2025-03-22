import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_event.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_state.dart';
import 'package:shurakhsa_kavach/core/widgets/custom_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _showOtpField = false;
  String? _verificationId;

  void _handleSendOtp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SendOtpEvent(
            phoneNumber: _phoneController.text,
          ));
    }
  }

  void _handleVerifyOtp() {
    if (_formKey.currentState!.validate()) {
      if (_verificationId == null) {
        CustomSnackBar.show(
          context,
          message: 'Please request OTP first',
          isSuccess: false,
        );
        return;
      }

      context.read<AuthBloc>().add(VerifyOtpEvent(
            phoneNumber: _phoneController.text,
            otp: _otpController.text,
            verificationId: _verificationId!,
          ));
    }
  }

  void _handleCreateUser() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(CreateUserEvent(
            name: _fullNameController.text,
            phoneNumber: _phoneController.text,
            password: _passwordController.text,
            otp: _otpController.text,
            verificationId: _verificationId,
          ));
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          CustomSnackBar.show(
            context,
            message: state.message,
            isSuccess: false,
          );
        } else if (state is OtpSent) {
          setState(() {
            _showOtpField = true;
            _verificationId = state.verificationId;
          });
          CustomSnackBar.show(
            context,
            message: 'OTP sent successfully!',
            isSuccess: true,
          );
        } else if (state is OtpVerified) {
          _handleCreateUser();
        } else if (state is AuthSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Registration successful!',
            isSuccess: true,
          );
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 48),
                      Text(
                        'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to get started',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(70),
                            ),
                      ),
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withAlpha(51),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withAlpha(51),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Full Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              enabled: !_showOtpField,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                // Add phone number validation if needed
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            if (_showOtpField) ...[
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter OTP',
                                  prefixIcon: Icon(
                                    Icons.key,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the OTP';
                                  }
                                  return null;
                                },
                              ),
                            ],
                            const SizedBox(height: 24),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    if (!_showOtpField) ...[
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: state is AuthLoading
                                              ? null
                                              : _handleSendOtp,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: state is AuthLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                )
                                              : const Text(
                                                  'Send OTP',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                      ),
                                    ] else ...[
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: state is AuthLoading
                                              ? null
                                              : _handleVerifyOtp,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: state is AuthLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                )
                                              : const Text(
                                                  'Verify OTP',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextButton(
                                        onPressed: state is AuthLoading
                                            ? null
                                            : _handleSendOtp,
                                        child: Text(
                                          'Resend OTP',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
