import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shurakhsa_kavach/blocs/address/address_event.dart';
import 'package:shurakhsa_kavach/blocs/address/address_state.dart';
import 'package:shurakhsa_kavach/models/address.dart';
import 'package:shurakhsa_kavach/repositories/database_repository.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final DatabaseRepository _databaseRepository;

  AddressBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(AddressInitial()) {
    on<AddOrUpdateAddressEvent>(_onAddOrUpdateAddress);
    on<LoadUserAddressesEvent>(_onLoadUserAddress);
  }

  Future<void> _onAddOrUpdateAddress(
    AddOrUpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      emit(AddressLoading());

      final address = Address(
        id: event.userId,
        userId: event.userId,
        houseName: event.houseName,
        street: event.street,
        city: event.district,
        state: event.state,
        country: 'India',
        zipCode: event.zipCode,
        landmark: event.landmark,
        coordinates: GeoPoint(event.latitude, event.longitude),
        isLocked: event.isLocked,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _databaseRepository.addOrUpdateAddress(address);
      emit(AddressAdded(address: address));
    } catch (e) {
      emit(AddressError(message: 'Failed to add address'));
    }
  }

  Future<void> _onLoadUserAddress(
    LoadUserAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      emit(AddressLoading());
      final address = await _databaseRepository.getUserAddress(event.userId);
      emit(AddressLoaded(address: address));
    } catch (e) {
      emit(AddressError(message: 'Failed to load address'));
    }
  }
}
