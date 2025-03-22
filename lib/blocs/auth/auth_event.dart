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
  final String verificationId;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otp,
    required this.verificationId,
  });

  @override
  List<Object?> get props => [phoneNumber, otp, verificationId];
}

class CreateUserEvent extends AuthEvent {
  final String phoneNumber;
  final String name;
  final String? password;
  final String? otp;
  final String? verificationId;

  const CreateUserEvent({
    required this.phoneNumber,
    required this.name,
    this.password,
    this.otp,
    this.verificationId,
  });

  @override
  List<Object?> get props => [phoneNumber, name, password, otp, verificationId];
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
  final String phoneNumber;
  final String newPassword;
  final String verificationId;
  final String otp;

  const UpdatePasswordEvent({
    required this.phoneNumber,
    required this.newPassword,
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, newPassword, verificationId, otp];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
