import 'package:flutter/material.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Service')),
      body: const Center(
        child: Text(
          'Add Service Screen - Placeholder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
