import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class PoliceEvent extends Equatable {
  const PoliceEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePoliceLocationEvent extends PoliceEvent {
  final LatLng location;

  const UpdatePoliceLocationEvent({required this.location});

  @override
  List<Object?> get props => [location];
}
