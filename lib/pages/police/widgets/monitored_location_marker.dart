import 'package:flutter/material.dart';

class MonitoredLocationMarker extends StatelessWidget {
  const MonitoredLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(180),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.home,
          color: Colors.white,
          size: 12,
        ),
      ),
    );
  }
}
