import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'models/service_record.dart';
import 'models/vehicle.dart';
import 'repositories/isar_service.dart';
import 'cubit/vehicle_cubit.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar database

  final isarService = IsarService();

  runApp(MyApp(isarService: isarService));
}

class MyApp extends StatelessWidget {
  final IsarService isarService;

  const MyApp({super.key, required this.isarService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleCubit(isarService),
      child: MaterialApp(
        title: 'OtoLog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
