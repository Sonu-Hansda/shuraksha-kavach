import 'package:equatable/equatable.dart';
import 'package:shurakhsa_kavach/models/address.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final Address? address;

  const AddressLoaded({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressError extends AddressState {
  final String message;

  const AddressError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddressAdded extends AddressState {
  final Address address;

  const AddressAdded({required this.address});

  @override
  List<Object?> get props => [address];
}
