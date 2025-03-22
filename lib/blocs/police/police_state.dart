import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:shurakhsa_kavach/models/address.dart';

abstract class PoliceState extends Equatable {
  const PoliceState();

  @override
  List<Object?> get props => [];
}

class PoliceInitial extends PoliceState {}

class PoliceLoading extends PoliceState {}

class PoliceLocationUpdated extends PoliceState {
  final LatLng location;
  final List<Address> monitoredLocations;

  const PoliceLocationUpdated(
      {required this.location, required this.monitoredLocations});

  @override
  List<Object?> get props => [location, monitoredLocations];
}

class PoliceError extends PoliceState {
  final String message;

  const PoliceError({required this.message});

  @override
  List<Object?> get props => [message];
}
