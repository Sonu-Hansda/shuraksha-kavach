import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, otp];
}

class CreateUserEvent extends AuthEvent {
  final String phoneNumber;
  final String name;
  final String? password;

  const CreateUserEvent({
    required this.phoneNumber,
    required this.name,
    this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, name, password];
}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginEvent({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, password];
}

class ResetPasswordEvent extends AuthEvent {
  final String phoneNumber;

  const ResetPasswordEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class UpdatePasswordEvent extends AuthEvent {
  final String newPassword;

  const UpdatePasswordEvent({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
