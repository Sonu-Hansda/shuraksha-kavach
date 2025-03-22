import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shurakhsa_kavach/blocs/police/police_event.dart';
import 'package:shurakhsa_kavach/blocs/police/police_state.dart';
import 'package:shurakhsa_kavach/models/address.dart';
import 'package:shurakhsa_kavach/repositories/database_repository.dart';

class PoliceBloc extends Bloc<PoliceEvent, PoliceState> {
  final DatabaseRepository _databaseRepository;

  PoliceBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(PoliceInitial()) {
    on<UpdatePoliceLocationEvent>(_onUpdatePoliceLocation);
  }

  Future<void> _onUpdatePoliceLocation(
    UpdatePoliceLocationEvent event,
    Emitter<PoliceState> emit,
  ) async {
    try {
      emit(PoliceLoading());
      List<Address> monitoredLocations =
          await _databaseRepository.getLockedAddresses();

      emit(PoliceLocationUpdated(
        location: event.location,
        monitoredLocations: monitoredLocations,
      ));
    } catch (e) {
      emit(PoliceError(message: 'Failed to load monitored locations: $e'));
    }
  }
}
