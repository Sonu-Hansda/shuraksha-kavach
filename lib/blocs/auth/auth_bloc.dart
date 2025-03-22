import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shurakhsa_kavach/repositories/auth_repository.dart';
import 'package:shurakhsa_kavach/repositories/database_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences prefs;
  final AuthRepository authRepository;
  final DatabaseRepository databaseRepository;

  AuthBloc({
    required this.prefs,
    required this.authRepository,
    required this.databaseRepository,
  }) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CreateUserEvent>(_onCreateUser);
    on<LoginEvent>(_onLogin);
    on<ResetPasswordEvent>(_onResetPassword);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        onCodeSent: (verificationId, resendToken) {
          emit(OtpSent(event.phoneNumber, verificationId: verificationId));
        },
        onVerificationCompleted: (message) {
          emit(OtpVerified(event.phoneNumber));
        },
        onVerificationFailed: (message) {
          emit(AuthFailure(message));
        },
      );
    } catch (e) {
      log('SendOtp Error: $e');
      if (e is AuthenticationException) {
        emit(AuthFailure(e.message));
      } else {
        emit(AuthFailure('Failed to send OTP. Please try again.'));
      }
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.verifyOTP(
        verificationId: event.verificationId,
        otp: event.otp,
      );
      emit(OtpVerified(event.phoneNumber));
    } catch (e) {
      log('VerifyOtp Error: $e');
      if (e is AuthenticationException) {
        emit(AuthFailure(e.message));
      } else {
        emit(AuthFailure('Failed to verify OTP. Please try again.'));
      }
    }
  }

  Future<void> _onCreateUser(
      CreateUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.signUpWithPhoneAndPassword(
        phoneNumber: event.phoneNumber,
        password: event.password!,
      );

      await databaseRepository.createUser(
        uid: credential.user!.uid,
        firstName: event.name.split(' ').first,
        lastName:
            event.name.split(' ').length > 1 ? event.name.split(' ').last : '',
        phoneNumber: event.phoneNumber,
      );

      emit(AuthSuccess(
        userId: credential.user!.uid,
        phoneNumber: event.phoneNumber,
        name: event.name,
        isNewUser: true,
      ));
    } catch (e) {
      log('CreateUser Error: $e');
      if (e is AuthenticationException) {
        emit(AuthFailure(e.message));
      } else {
        emit(AuthFailure('Failed to create account. Please try again.'));
      }
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = await authRepository.signInWithPhoneAndPassword(
        phoneNumber: event.phoneNumber,
        password: event.password,
      );

      final user = await databaseRepository.getUser(credential.user!.uid);

      emit(AuthSuccess(
        userId: user.uid,
        phoneNumber: user.phoneNumber,
        name: user.fullName,
      ));
    } catch (e) {
      log('Login Error: $e');
      if (e is AuthenticationException) {
        emit(AuthFailure(e.message));
      } else {
        emit(AuthFailure('Failed to sign in. Please try again.'));
      }
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        onCodeSent: (verificationId, resendToken) {
          emit(OtpSent(event.phoneNumber, verificationId: verificationId));
        },
        onVerificationCompleted: (message) {
          emit(OtpVerified(event.phoneNumber));
        },
        onVerificationFailed: (message) {
          emit(AuthFailure(message));
        },
      );
    } catch (e) {
      log('ResetPassword Error: $e');
      if (e is AuthenticationException) {
        emit(AuthFailure(e.message));
      } else {
        emit(AuthFailure(
            'Failed to initiate password reset. Please try again.'));
      }
    }
  }

  Future<void> _onUpdatePassword(
      UpdatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.resetPasswordWithPhone(
        phoneNumber: event.phoneNumber,
        newPassword: event.newPassword,
        verificationId: event.verificationId,
        otp: event.otp,
      );
      emit(PasswordResetSuccess());
    } catch (e) {
      log('UpdatePassword Error: $e');
      if (e is AuthenticationException) {
        emit(AuthFailure(e.message));
      } else {
        emit(AuthFailure('Failed to update password. Please try again.'));
      }
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(LoggedOut());
    } catch (e) {
      log('Logout Error: $e');
      if (e is AuthenticationException) {
        emit(AuthFailure(e.message));
      } else {
        emit(AuthFailure('Failed to sign out. Please try again.'));
      }
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final currentUser = authRepository.currentUser;
      if (currentUser != null) {
        final user = await databaseRepository.getUser(currentUser.uid);
        emit(AuthSuccess(
          userId: user.uid,
          phoneNumber: user.phoneNumber,
          name: user.fullName,
        ));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      log('CheckAuthStatus Error: $e');
      if (e is AuthenticationException) {
        emit(AuthFailure(e.message));
      } else {
        emit(AuthFailure(
            'Failed to check authentication status. Please try again.'));
      }
    }
  }
}
