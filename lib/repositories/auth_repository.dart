import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shurakhsa_kavach/core/services/sms_service.dart';

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
}

class OtpVerificationResult {
  final bool isNewUser;
  final String phoneNumber;

  OtpVerificationResult({
    required this.isNewUser,
    required this.phoneNumber,
  });
}

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final SmsService _smsService;
  final Map<String, String> _otpStorage = {}; // Temporary storage for OTPs

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    SmsService? smsService,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _smsService = smsService ?? SmsService();

  String _generateOtp() {
    return (100000 + Random().nextInt(900000)).toString(); // 6-digit OTP
  }

  String _phoneNumberToEmail(String phoneNumber) {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\+\d]'), '');
    return '$cleanPhone@shurakhsa.com';
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signUpWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final email = _phoneNumberToEmail(phoneNumber);
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            throw AuthenticationException('Phone number already registered');
          case 'weak-password':
            throw AuthenticationException('Password is too weak');
          default:
            throw AuthenticationException(e.message ?? 'Failed to sign up');
        }
      }
      throw AuthenticationException('Failed to sign up: $e');
    }
  }

  Future<UserCredential> signInWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final email = _phoneNumberToEmail(phoneNumber);
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw AuthenticationException(
                'No user found with this phone number');
          case 'wrong-password' || 'invalid-credential':
            throw AuthenticationException('Invalid credentials');
          default:
            throw AuthenticationException(e.message ?? 'Failed to sign in');
        }
      }
      throw AuthenticationException('Failed to sign in: $e');
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationCompleted,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      // Using predefined OTP temporarily until SMS service is ready
      const otp = '112334';
      _otpStorage[phoneNumber] = otp;

      // Using phone number as verification ID temporarily
      onCodeSent(phoneNumber, null);
    } catch (e) {
      onVerificationFailed('Failed to process OTP request: $e');
    }
  }

  Future<OtpVerificationResult> verifyOTP({
    required String verificationId,
    required String otp,
    required String phoneNumber,
  }) async {
    try {
      // Verify OTP from storage
      final storedOtp = _otpStorage[phoneNumber];
      if (storedOtp == null) {
        throw AuthenticationException('OTP expired. Please request a new one.');
      }

      if (otp != storedOtp) {
        throw AuthenticationException('Invalid OTP');
      }

      // Clear OTP after successful verification
      _otpStorage.remove(phoneNumber);

      // Check if user exists by attempting to sign in with a dummy password
      final email = _phoneNumberToEmail(phoneNumber);
      bool isNewUser = true;
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: 'dummy-password',
        );
        isNewUser = false;
      } on FirebaseAuthException catch (e) {
        if (e.code != 'user-not-found') {
          isNewUser = false;
        }
      }

      // Sign out if we accidentally signed in
      if (!isNewUser) {
        await _firebaseAuth.signOut();
      }

      return OtpVerificationResult(
        isNewUser: isNewUser,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      if (e is AuthenticationException) {
        rethrow;
      }
      throw AuthenticationException('Failed to verify OTP: $e');
    }
  }

  Future<void> resetPasswordWithPhone({
    required String phoneNumber,
    required String newPassword,
    required String verificationId,
    required String otp,
  }) async {
    try {
      final email = _phoneNumberToEmail(phoneNumber);

      // Try to sign in with dummy password to check if user exists
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: 'dummy-password',
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          throw AuthenticationException(
              'No account found with this phone number');
        }
      }

      // Verify OTP
      final storedOtp = _otpStorage[phoneNumber];
      if (storedOtp == null || storedOtp != otp) {
        throw AuthenticationException('Invalid OTP');
      }

      // Update password
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      if (e is AuthenticationException) {
        throw e;
      }
      throw AuthenticationException('Failed to reset password: $e');
    }
  }

  Future<void> updateUserProfile({
    required String displayName,
  }) async {
    try {
      await _firebaseAuth.currentUser?.updateProfile(
        displayName: displayName,
      );
    } catch (e) {
      throw AuthenticationException('Failed to update profile: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthenticationException('Failed to sign out: $e');
    }
  }
}
