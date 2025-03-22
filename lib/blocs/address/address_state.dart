import 'package:equatable/equatable.dart';
import 'package:shurakhsa_kavach/models/address.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressSuccess extends AddressState {
  final List<Address> addresses;

  const AddressSuccess({required this.addresses});

  @override
  List<Object?> get props => [addresses];
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

class AddressUpdated extends AddressState {
  final Address address;

  const AddressUpdated({required this.address});

  @override
  List<Object?> get props => [address];
}

class LockStatusUpdated extends AddressState {
  final String addressId;
  final bool isLocked;

  const LockStatusUpdated({
    required this.addressId,
    required this.isLocked,
  });

  @override
  List<Object?> get props => [addressId, isLocked];
}
