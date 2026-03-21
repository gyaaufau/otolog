import 'package:flutter/material.dart';

class VehicleDetailScreen extends StatelessWidget {
  const VehicleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Detail')),
      body: const Center(
        child: Text(
          'Vehicle Detail Screen - Placeholder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
