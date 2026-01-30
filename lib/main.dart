import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'models/service_record.dart';
import 'models/vehicle.dart';
import 'repositories/isar_service.dart';
import 'cubit/vehicle_cubit.dart';
import 'screens/home_screen.dart';
import 'constants/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar database and wait for it to be ready
  final isarService = IsarService();
  await isarService.db;

  runApp(MyApp(isarService: isarService));
}

class MyApp extends StatelessWidget {
  final IsarService isarService;

  const MyApp({super.key, required this.isarService});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => VehicleCubit(isarService),
          child: MaterialApp(
            title: 'OtoLog',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.background,
              colorScheme: ColorScheme.dark(
                primary: AppColors.accent,
                secondary: AppColors.accent,
                surface: AppColors.surface,
                onPrimary: AppColors.primaryText,
                onSecondary: AppColors.primaryText,
                onSurface: AppColors.primaryText,
                error: AppColors.error,
              ),
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.primaryText,
                elevation: 0,
                centerTitle: true,
              ),
              cardTheme: CardThemeData(
                color: AppColors.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppColors.inputBackground,
                hintStyle: TextStyle(color: AppColors.secondaryText),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.accent),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.error),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.accent),
              ),
              iconTheme: IconThemeData(color: AppColors.primaryText),
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                ),
                displayMedium: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
                displaySmall: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                headlineMedium: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
                titleLarge: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 16.sp,
                ),
                bodyMedium: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14.sp,
                ),
                bodySmall: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12.sp,
                ),
              ),
            ),
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
