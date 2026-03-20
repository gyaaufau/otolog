import 'package:flutter/material.dart';

class EditVehicleScreen extends StatelessWidget {
  const EditVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Vehicle')),
      body: const Center(
        child: Text(
          'Edit Vehicle Screen - Placeholder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
