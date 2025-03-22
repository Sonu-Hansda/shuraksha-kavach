import 'package:equatable/equatable.dart';
import 'package:shurakhsa_kavach/enums/user_type.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String phoneNumber;
  final String verificationId;

  const OtpSent(this.phoneNumber, {required this.verificationId});

  @override
  List<Object?> get props => [phoneNumber, verificationId];
}

class OtpVerified extends AuthState {
  final String phoneNumber;

  const OtpVerified(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthSuccess extends AuthState {
  final String userId;
  final String phoneNumber;
  final UserType role;
  final String? name;
  final bool isNewUser;

  const AuthSuccess({
    required this.userId,
    required this.phoneNumber,
    required this.role,
    this.name,
    this.isNewUser = false,
  });

  @override
  List<Object?> get props => [userId, phoneNumber, name, isNewUser, role];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetSuccess extends AuthState {}

class LoggedOut extends AuthState {}
