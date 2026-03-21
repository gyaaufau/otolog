import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Detail')),
      body: const Center(
        child: Text(
          'Service Detail Screen - Placeholder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
