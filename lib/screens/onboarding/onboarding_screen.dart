import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:otolog/cubit/currency_cubit.dart';
import 'package:otolog/cubit/language_cubit.dart';
import 'package:otolog/cubit/unit_cubit.dart';
import 'package:otolog/resources/colors.dart';
import 'package:otolog/repositories/onboarding_repository.dart';
import 'package:otolog/router.dart';
import 'package:otolog/shared/constants/currency.dart';
import 'package:otolog/shared/constants/unit.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';
import 'package:otolog/shared/core/service_locator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _showPreferences = false;

  Future<void> _completeAndGoHome() async {
    await sl<OnboardingRepository>().complete();
    if (!mounted) {
      return;
    }

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral[50],
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child:
              _showPreferences
                  ? _PreferencesStep(
                    key: const ValueKey('preferences'),
                    onDone: _completeAndGoHome,
                  )
                  : _IntroStep(
                    key: const ValueKey('intro'),
                    onContinue: () {
                      setState(() {
                        _showPreferences = true;
                      });
                    },
                    onSkip: _completeAndGoHome,
                  ),
        ),
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({super.key, required this.onContinue, required this.onSkip});

  final VoidCallback onContinue;
  final Future<void> Function() onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'OtoLog',
                style: TextStyle(
                  color: AppColors.neutral[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onSkip,
                child: Text(l10n.onboardingSkip),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral[900]!.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: const Icon(
                        Icons.directions_car_filled_rounded,
                        color: AppColors.primary,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.onboardingTitleOne,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.neutral[900],
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.onboardingDescriptionOne,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.neutral[600],
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l10n.next,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesStep extends StatelessWidget {
  const _PreferencesStep({super.key, required this.onDone});

  final Future<void> Function() onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                l10n.settings,
                style: TextStyle(
                  color: AppColors.neutral[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const Spacer(),
              TextButton(onPressed: onDone, child: Text(l10n.done)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingPreferencesTitle,
            style: TextStyle(
              color: AppColors.neutral[900],
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.onboardingPreferencesDescription,
            style: TextStyle(
              color: AppColors.neutral[600],
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SectionCard(
                    icon: Icons.language_rounded,
                    title: l10n.language,
                    accentColor: AppColors.primary,
                    child: BlocBuilder<LanguageCubit, LanguageState>(
                      builder: (context, state) {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              AppLocales.supportedLocales.map((locale) {
                                final isSelected = state.locale == locale;
                                return _ChoiceChip(
                                  label: AppLocales.getLocaleDisplayName(
                                    locale,
                                  ),
                                  isSelected: isSelected,
                                  onTap:
                                      () => context
                                          .read<LanguageCubit>()
                                          .changeLanguage(locale),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    icon: Icons.straighten_rounded,
                    title: l10n.distanceUnit,
                    accentColor: AppColors.secondary[500]!,
                    child: BlocBuilder<UnitCubit, UnitState>(
                      builder: (context, state) {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              DistanceUnit.values.map((unit) {
                                final isSelected = state.unit == unit;
                                final label =
                                    unit == DistanceUnit.km
                                        ? l10n.km
                                        : l10n.miles;
                                return _ChoiceChip(
                                  label: label,
                                  isSelected: isSelected,
                                  onTap:
                                      () => context
                                          .read<UnitCubit>()
                                          .changeUnit(unit),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    icon: Icons.payments_rounded,
                    title: l10n.currency,
                    accentColor: AppColors.tertiary,
                    child: BlocBuilder<CurrencyCubit, CurrencyState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap:
                              () =>
                                  _showCurrencyDialog(context, state.currency),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.neutral[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.neutral[200]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${state.currency.symbol} ${state.currency.code}',
                                        style: TextStyle(
                                          color: AppColors.neutral[900],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        state.currency.fullName,
                                        style: TextStyle(
                                          color: AppColors.neutral[600],
                                          fontSize: 13,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.neutral[500],
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l10n.done,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral[900]!.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.neutral[900],
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.neutral[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primary.withValues(alpha: 0.55)
                    : AppColors.neutral[200]!,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color:
                      isSelected ? AppColors.primary : AppColors.neutral[700],
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                child: Text(label),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: isSelected ? 24 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                opacity: isSelected ? 1 : 0,
                child: const Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showCurrencyDialog(BuildContext context, Currency currentCurrency) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (context) =>
            _CurrencySelectionBottomSheet(currentCurrency: currentCurrency),
  );
}

class _CurrencySelectionBottomSheet extends StatelessWidget {
  const _CurrencySelectionBottomSheet({required this.currentCurrency});

  final Currency currentCurrency;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.currency,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral[900],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.neutral[500],
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: Currency.values.length,
                      itemBuilder: (context, index) {
                        final currency = Currency.values[index];
                        final isSelected = currency == currentCurrency;

                        return _buildCurrencyOption(
                          context,
                          displayName: currency.fullName,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<CurrencyCubit>().changeCurrency(
                              currency,
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.neutral[400],
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(
    BuildContext context, {
    required String displayName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.tertiary.withValues(alpha: 0.08)
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected ? AppColors.tertiary : AppColors.neutral[900],
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: AppColors.tertiary, size: 20),
          ],
        ),
      ),
    );
  }
}
