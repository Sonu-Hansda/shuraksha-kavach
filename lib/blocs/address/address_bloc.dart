import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shurakhsa_kavach/blocs/address/address_event.dart';
import 'package:shurakhsa_kavach/blocs/address/address_state.dart';
import 'package:shurakhsa_kavach/models/address.dart';
import 'package:shurakhsa_kavach/repositories/database_repository.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _addressesSubscription;

  AddressBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(AddressInitial()) {
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<ToggleLockStatusEvent>(_onToggleLockStatus);
    on<LoadUserAddressesEvent>(_onLoadUserAddresses);
    on<LoadLockedAddressesEvent>(_onLoadLockedAddresses);
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      emit(AddressLoading());

      final address = Address(
        id: '',
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

      final addressId = await _databaseRepository.addAddress(address);

      final updatedAddress = Address(
        id: addressId,
        userId: address.userId,
        houseName: address.houseName,
        street: address.street,
        city: address.city,
        state: address.state,
        country: address.country,
        zipCode: address.zipCode,
        landmark: address.landmark,
        coordinates: address.coordinates,
        isLocked: address.isLocked,
        createdAt: address.createdAt,
        updatedAt: address.updatedAt,
      );

      emit(AddressAdded(address: updatedAddress));
    } catch (e) {
      emit(AddressError(message: 'Failed to add address: $e'));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      emit(AddressLoading());
      await _databaseRepository.updateAddress(event.addressId, event.data);
    } catch (e) {
      emit(AddressError(message: 'Failed to update address: $e'));
    }
  }

  Future<void> _onToggleLockStatus(
    ToggleLockStatusEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      emit(AddressLoading());
      await _databaseRepository.updateAddress(
        event.addressId,
        {'isLocked': event.isLocked},
      );
      emit(LockStatusUpdated(
        addressId: event.addressId,
        isLocked: event.isLocked,
      ));
    } catch (e) {
      emit(AddressError(message: 'Failed to update lock status: $e'));
    }
  }

  Future<void> _onLoadUserAddresses(
    LoadUserAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      emit(AddressLoading());
      _addressesSubscription?.cancel();
      _addressesSubscription = _databaseRepository
          .userAddressesStream(event.userId)
          .listen((addresses) {
        add(_UpdateAddressesEvent(addresses));
      });
    } catch (e) {
      emit(AddressError(message: 'Failed to load addresses: $e'));
    }
  }

  Future<void> _onLoadLockedAddresses(
    LoadLockedAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    // This would be implemented when we add the functionality to fetch locked addresses
    // For police officers to monitor
  }

  @override
  Future<void> close() {
    _addressesSubscription?.cancel();
    return super.close();
  }
}

class _UpdateAddressesEvent extends AddressEvent {
  final List<Address> addresses;

  const _UpdateAddressesEvent(this.addresses);

  @override
  List<Object?> get props => [addresses];
}
