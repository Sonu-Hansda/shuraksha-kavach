import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapSheet extends StatelessWidget {
  final MapController mapController;
  final LatLng? currentLocation;
  final LatLng defaultLocation;
  final LatLng? selectedLocation;
  final bool isLoadingLocation;
  final Function(TapPosition, LatLng) onMapTap;
  final VoidCallback onGetCurrentLocation;
  final VoidCallback onConfirmLocation;

  const LocationMapSheet({
    super.key,
    required this.mapController,
    required this.currentLocation,
    required this.defaultLocation,
    required this.selectedLocation,
    required this.isLoadingLocation,
    required this.onMapTap,
    required this.onGetCurrentLocation,
    required this.onConfirmLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Location',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: onGetCurrentLocation,
                  icon: Icon(
                    Icons.my_location_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  tooltip: 'Get Current Location',
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: currentLocation ?? defaultLocation,
                          initialZoom: 15,
                          onTap: onMapTap,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.example.shurakhsa_kavach',
                          ),
                          MarkerLayer(
                            markers: [
                              if (currentLocation != null)
                                Marker(
                                  point: currentLocation!,
                                  width: 50,
                                  height: 50,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 800),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, value, child) {
                                      return Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withAlpha(30),
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Opacity(
                                            opacity: (1 - value) * 0.4,
                                            child: Transform.scale(
                                              scale: 1 + value,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              if (selectedLocation != null &&
                                  selectedLocation != currentLocation)
                                Marker(
                                  point: selectedLocation!,
                                  width: 50,
                                  height: 50,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 300),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, -10 * value),
                                        child: Transform.scale(
                                          scale: 0.6 + (0.4 * value),
                                          child: Icon(
                                            Icons.location_on,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            size: 50,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      if (isLoadingLocation)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black26,
                            child: Center(
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Getting your location...',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 24,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tap on the map to select your location',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedLocation != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Location selected at: ${selectedLocation!.latitude.toStringAsFixed(6)}, ${selectedLocation!.longitude.toStringAsFixed(6)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                FilledButton(
                  onPressed:
                      selectedLocation != null ? onConfirmLocation : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Confirm Location',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
