import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_bloc.dart';
import 'package:shurakhsa_kavach/blocs/auth/auth_state.dart';
import 'package:shurakhsa_kavach/blocs/police/police_bloc.dart';
import 'package:shurakhsa_kavach/blocs/police/police_event.dart';
import 'package:shurakhsa_kavach/blocs/police/police_state.dart';
import 'package:shurakhsa_kavach/pages/home/widgets/logout_button.dart';
import 'package:shurakhsa_kavach/pages/police/widgets/location_details_dialog.dart';
import 'package:shurakhsa_kavach/pages/police/widgets/map_controls.dart';
import 'package:shurakhsa_kavach/pages/police/widgets/map_legend.dart';
import 'package:shurakhsa_kavach/pages/police/widgets/monitored_location_marker.dart';

class PoliceScreen extends StatefulWidget {
  const PoliceScreen({super.key});

  @override
  State<PoliceScreen> createState() => _PoliceScreenState();
}

class _PoliceScreenState extends State<PoliceScreen> {
  final MapController _mapController = MapController();
  bool _isLoadingLocation = false;
  StreamSubscription<Position>? _positionStream;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _setupLocationTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _setupLocationTracking() async {
    setState(() => _isLoadingLocation = true);

    try {
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      // Get initial location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.best),
      );

      context.read<PoliceBloc>().add(
            UpdatePoliceLocationEvent(
              location: LatLng(position.latitude, position.longitude),
            ),
          );

      setState(() => _isLoadingLocation = false);

      // Start location stream
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        context.read<PoliceBloc>().add(
              UpdatePoliceLocationEvent(
                location: LatLng(position.latitude, position.longitude),
              ),
            );
      });
    } catch (e) {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _centerOnLocation(LatLng location) {
    _mapController.move(location, 15.0);
  }

  void _resetRotation() {
    setState(() {
      _rotation = 0.0;
      _mapController.rotate(0.0);
    });
  }

  void _showLocationDetails(BuildContext context, address) {
    showDialog(
      context: context,
      builder: (context) => LocationDetailsDialog(address: address),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedOut) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/landing',
            (route) => false,
          );
        }
      },
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
          child: BlocConsumer<PoliceBloc, PoliceState>(
            listener: (context, state) {
              if (state is PoliceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    title: Text(
                      'Police Screen',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                  const SliverPadding(
                    padding: EdgeInsets.only(bottom: 16),
                  ),
                  SliverFillRemaining(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: state is PoliceLocationUpdated
                                ? state.location
                                : const LatLng(22.777306, 86.145222),
                            initialZoom: 15.0,
                            onMapReady: () {
                              _mapController.rotate(_rotation);
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(
                              markers: [
                                // Current location marker
                                if (state is PoliceLocationUpdated) ...[
                                  Marker(
                                    point: state.location,
                                    width: 150,
                                    height: 150,
                                    child: RepaintBoundary(
                                      child: Stack(
                                        children: [
                                          Center(
                                            child:
                                                TweenAnimationBuilder<double>(
                                              tween:
                                                  Tween(begin: 0.0, end: 1.0),
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                              builder: (context, value, child) {
                                                return Transform.scale(
                                                  scale: 0.2 + (value * 0.8),
                                                  child: Container(
                                                    width: 75,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.blue
                                                          .withAlpha(60),
                                                    ),
                                                  ),
                                                );
                                              },
                                              onEnd: () {
                                                if (mounted) setState(() {});
                                              },
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue[600],
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 4,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(30),
                                                    blurRadius: 8,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ...state.monitoredLocations.map(
                                    (address) => Marker(
                                      point: LatLng(
                                        address.coordinates.latitude,
                                        address.coordinates.longitude,
                                      ),
                                      width: 30,
                                      height: 30,
                                      child: GestureDetector(
                                        onTap: () => _showLocationDetails(
                                            context, address),
                                        child: TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0.8, end: 1.2),
                                          duration: const Duration(seconds: 1),
                                          builder: (context, value, child) {
                                            return Transform.scale(
                                              scale: value,
                                              child:
                                                  const MonitoredLocationMarker(),
                                            );
                                          },
                                          onEnd: () {
                                            if (mounted) setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        if (_isLoadingLocation || state is PoliceLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        Positioned(
                          right: 16,
                          top: 16,
                          child: MapControls(
                            onResetRotation: _resetRotation,
                            onCenterLocation: _centerOnLocation,
                            currentLocation: state is PoliceLocationUpdated
                                ? state.location
                                : null,
                            rotation: _rotation,
                          ),
                        ),
                        const Positioned(
                          right: 16,
                          bottom: 16,
                          child: MapLegend(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
