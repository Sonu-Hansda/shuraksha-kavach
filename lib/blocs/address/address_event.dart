import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class AddOrUpdateAddressEvent extends AddressEvent {
  final String houseName;
  final String street;
  final String district;
  final String state;
  final double latitude;
  final double longitude;
  final String userId;
  final bool isLocked;
  final String zipCode;
  final String landmark;

  const AddOrUpdateAddressEvent({
    required this.houseName,
    required this.street,
    required this.district,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.zipCode,
    required this.landmark,
    this.isLocked = false,
  });

  @override
  List<Object?> get props => [
        houseName,
        street,
        district,
        state,
        latitude,
        longitude,
        userId,
        zipCode,
        landmark,
        isLocked,
      ];
}

class LoadUserAddressesEvent extends AddressEvent {
  final String userId;

  const LoadUserAddressesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
