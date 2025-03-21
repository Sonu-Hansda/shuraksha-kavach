import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs;

  AuthBloc(this._prefs) : super(AuthInitial()) {
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
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // For now, accept any phone number and simulate OTP sending
      emit(OtpSent(event.phoneNumber));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Hardcoded OTP verification
      if (event.otp == '112334') {
        emit(OtpVerified(event.phoneNumber));
      } else {
        emit(const AuthFailure('Invalid OTP'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onCreateUser(
      CreateUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Store user data in SharedPreferences
      await _prefs.setString('user_id', 'user_${event.phoneNumber}');
      await _prefs.setString('phone_number', event.phoneNumber);
      await _prefs.setString('name', event.name);
      if (event.password != null) {
        await _prefs.setString('password', event.password!);
      }

      emit(AuthSuccess(
        userId: 'user_${event.phoneNumber}',
        phoneNumber: event.phoneNumber,
        name: event.name,
        isNewUser: true,
      ));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Hardcoded login verification
      if (event.phoneNumber == '7033167930' && event.password == 'Sonu123') {
        emit(AuthSuccess(
          userId: 'user_${event.phoneNumber}',
          phoneNumber: event.phoneNumber,
          name: 'Sonu', // Hardcoded name
        ));
      } else {
        emit(const AuthFailure('Invalid phone number or password'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // For now, accept any phone number and simulate OTP sending
      emit(OtpSent(event.phoneNumber));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onUpdatePassword(
      UpdatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Update password in SharedPreferences
      await _prefs.setString('password', event.newPassword);
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Clear user data from SharedPreferences
      await _prefs.clear();
      emit(LoggedOut());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Check if user is logged in using SharedPreferences
      final userId = _prefs.getString('user_id');
      final phoneNumber = _prefs.getString('phone_number');
      final name = _prefs.getString('name');

      if (userId != null && phoneNumber != null) {
        emit(AuthSuccess(
          userId: userId,
          phoneNumber: phoneNumber,
          name: name,
        ));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
