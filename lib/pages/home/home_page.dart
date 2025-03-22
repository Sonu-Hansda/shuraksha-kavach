import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_state.dart';
import 'package:shurakhsa_kavach/blocs/address/address_bloc.dart';
import 'package:shurakhsa_kavach/blocs/address/address_event.dart';
import 'package:shurakhsa_kavach/blocs/address/address_state.dart';
import 'package:shurakhsa_kavach/models/address.dart';
import 'package:shurakhsa_kavach/pages/home/widgets/address_form_fields.dart';
import 'package:shurakhsa_kavach/pages/home/widgets/location_map_sheet.dart';
import 'package:shurakhsa_kavach/pages/home/widgets/lock_button.dart';
import 'package:shurakhsa_kavach/pages/home/widgets/logout_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLocked = false;
  late AnimationController _lockAnimationController;
  late Animation<double> _lockAnimation;
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  final LatLng _defaultLocation = LatLng(22.777306, 86.145222);
  bool _isMapLoading = true;
  String _selectedAddress = 'Select Location on Map';
  bool _isLoadingLocation = false;
  double _currentZoom = 15.0;
  late final TextEditingController _houseNameController;
  late final TextEditingController _streetController;
  late final TextEditingController _districtController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _landmarkController;

  @override
  void initState() {
    super.initState();
    _lockAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _lockAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _lockAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _getCurrentLocation();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<AddressBloc>().add(
            LoadUserAddressesEvent(userId: authState.userId),
          );
    }

    _houseNameController = TextEditingController();
    _streetController = TextEditingController();
    _districtController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _landmarkController = TextEditingController();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation;
        _selectedAddress = 'Current Location Selected';
        _isLoadingLocation = false;
      });

      _mapController.move(_currentLocation!, 18.0);
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() => _isLoadingLocation = false);
    }
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
      _currentZoom = _mapController.camera.zoom;
    });

    _mapController.move(point, _currentZoom);
  }

  @override
  void dispose() {
    _lockAnimationController.dispose();
    _mapController.dispose();
    _houseNameController.dispose();
    _streetController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LocationMapSheet(
        mapController: _mapController,
        currentLocation: _currentLocation,
        defaultLocation: _defaultLocation,
        selectedLocation: _selectedLocation,
        isLoadingLocation: _isLoadingLocation,
        onMapTap: _handleMapTap,
        onGetCurrentLocation: _getCurrentLocation,
        onConfirmLocation: () {
          setState(() {
            _selectedAddress = 'Location Selected';
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
      if (_isLocked) {
        _lockAnimationController.forward();
      } else {
        _lockAnimationController.reverse();
      }
    });
  }

  void _handleAddAddress() {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location on the map'),
        ),
      );
      return;
    }

    if (_houseNameController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _districtController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _zipCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required address fields'),
        ),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<AddressBloc>().add(
            AddAddressEvent(
              houseName: _houseNameController.text,
              street: _streetController.text,
              district: _districtController.text,
              state: _stateController.text,
              zipCode: _zipCodeController.text,
              landmark: _landmarkController.text,
              latitude: _selectedLocation!.latitude,
              longitude: _selectedLocation!.longitude,
              userId: authState.userId,
              isLocked: _isLocked,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to add an address'),
        ),
      );
    }
  }

  void _fillFormWithAddress(Address address) {
    _houseNameController.text = address.houseName;
    _streetController.text = address.street;
    _districtController.text = address.city;
    _stateController.text = address.state;
    _zipCodeController.text = address.zipCode;
    _landmarkController.text = address.landmark ?? '';
    setState(() {
      _selectedLocation = LatLng(
        address.coordinates.latitude,
        address.coordinates.longitude,
      );
      _selectedAddress = 'Location Selected';
      _isLocked = address.isLocked;
      if (_isLocked) {
        _lockAnimationController.forward();
      } else {
        _lockAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddressBloc, AddressState>(
          listener: (context, state) {
            if (state is AddressError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is AddressAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address added successfully')),
              );
              // Clear the form
              _houseNameController.clear();
              _streetController.clear();
              _districtController.clear();
              _stateController.clear();
              _zipCodeController.clear();
              _landmarkController.clear();
              setState(() {
                _selectedLocation = null;
                _selectedAddress = 'Select Location on Map';
                _isLocked = false;
                _lockAnimationController.reverse();
              });
            } else if (state is AddressesLoaded && state.addresses.isNotEmpty) {
              // Fill form with the first address if available
              _fillFormWithAddress(state.addresses.first);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial || state is LoggedOut) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/landing',
                (route) => false,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Text(
                  'Home Details',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: const [
                  LogoutButton(),
                  SizedBox(width: 8),
                ],
              ),
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withAlpha(51),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withAlpha(51),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                AddressFormFields(
                                  houseNameController: _houseNameController,
                                  streetController: _streetController,
                                  districtController: _districtController,
                                  stateController: _stateController,
                                  zipCodeController: _zipCodeController,
                                  landmarkController: _landmarkController,
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _showLocationBottomSheet,
                                    icon: Icon(
                                      Icons.map,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    label: Text(
                                      _selectedAddress,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                          Center(
                            child: LockButton(
                              isLocked: _isLocked,
                              lockAnimation: _lockAnimation,
                              onTap: _toggleLock,
                            ),
                          ),
                          if (_isLocked) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Your Home is Protected',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'You are safe with us',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(70),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _handleAddAddress,
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Save Address',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onTertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
