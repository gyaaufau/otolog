import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otolog/cubit/currency_cubit.dart';
import 'package:otolog/cubit/language_cubit.dart';
import 'package:otolog/cubit/service_vehicle_selector_cubit.dart';
import 'package:otolog/cubit/unit_cubit.dart';
import 'package:otolog/l10n/app_localizations.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';

import 'cubit/vehicle_cubit.dart';
import 'cubit/vehicle_detail_cubit.dart';
import 'cubit/vehicle_list_cubit.dart';
import 'repositories/onboarding_repository.dart';
import 'resources/theme.dart';
import 'router.dart';
import 'shared/core/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  final showOnboarding = !await sl<OnboardingRepository>().isCompleted();

  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<VehicleCubit>()),
            BlocProvider(create: (context) => sl<VehicleListCubit>()),
            BlocProvider(create: (context) => sl<VehicleDetailCubit>()),
            BlocProvider(
              create: (context) => sl<ServiceVehicleSelectorCubit>(),
            ),
            BlocProvider(create: (context) => sl<LanguageCubit>()),
            BlocProvider(create: (context) => sl<UnitCubit>()),
            BlocProvider(create: (context) => sl<CurrencyCubit>()),
          ],
          child: AppView(showOnboarding: showOnboarding),
        );
      },
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final goRouter = createRouter(showOnboarding: widget.showOnboarding);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'OtoLog',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: goRouter,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocales.supportedLocales,
          locale: state.locale,
        );
      },
    );
  }
}
