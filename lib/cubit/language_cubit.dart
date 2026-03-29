import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otolog/shared/localization/l10n_helper.dart';
import 'package:otolog/repositories/language_repository.dart';

/// Events for LanguageCubit
abstract class LanguageEvent {}

/// Event to change the language
class LanguageChanged extends LanguageEvent {
  final Locale locale;

  LanguageChanged(this.locale);
}

/// Event to load the saved language
class LanguageLoaded extends LanguageEvent {}

/// State for LanguageCubit
class LanguageState extends Equatable {
  final Locale locale;
  final bool isLoading;

  const LanguageState({required this.locale, this.isLoading = false});

  LanguageState copyWith({Locale? locale, bool? isLoading}) {
    return LanguageState(
      locale: locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [locale, isLoading];
}

/// Cubit for managing app language selection
class LanguageCubit extends Cubit<LanguageState> {
  final LanguageRepository _languageRepository;

  LanguageCubit(this._languageRepository)
    : super(LanguageState(locale: const Locale('en'))) {
    _loadLanguage();
  }

  /// Load the saved language from repository
  Future<void> _loadLanguage() async {
    emit(state.copyWith(isLoading: true));

    try {
      final savedLocale = await _languageRepository.getSavedLocale();
      if (savedLocale != null) {
        emit(LanguageState(locale: savedLocale));
      } else {
        // If no saved locale, default to English
        emit(LanguageState(locale: const Locale('en')));
      }
    } catch (e) {
      // If there's an error loading, default to English
      emit(LanguageState(locale: const Locale('en')));
    }
  }

  /// Change the app language
  Future<void> changeLanguage(Locale locale) async {
    if (state.locale == locale) return;

    emit(state.copyWith(isLoading: true));

    try {
      await _languageRepository.saveLocale(locale);
      emit(LanguageState(locale: locale));
    } catch (e) {
      // If saving fails, still update the state but log the error
      emit(LanguageState(locale: locale));
    }
  }

  /// Get the current locale
  Locale get currentLocale => state.locale;

  /// Get the display name of the current locale
  String get currentLocaleDisplayName =>
      AppLocales.getLocaleDisplayName(state.locale);
}
