import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onResetRotation;
  final Function(LatLng location) onCenterLocation;
  final LatLng? currentLocation;
  final double rotation;

  const MapControls({
    super.key,
    required this.onResetRotation,
    required this.onCenterLocation,
    required this.currentLocation,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: 'centerLocation',
          onPressed: () {
            if (currentLocation != null) {
              onCenterLocation(currentLocation!);
            }
          },
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.my_location,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'resetRotation',
          onPressed: onResetRotation,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Transform.rotate(
            angle: rotation * 3.14159 / 180,
            child: Icon(
              Icons.explore,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
