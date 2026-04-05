import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otolog/repositories/currency_repository.dart';
import 'package:otolog/shared/constants/currency.dart';

/// Events for CurrencyCubit
abstract class CurrencyEvent {}

/// Event to change the currency symbol
class CurrencyChanged extends CurrencyEvent {
  final Currency currency;

  CurrencyChanged(this.currency);
}

/// Event to load the saved currency
class CurrencyLoaded extends CurrencyEvent {}

/// State for CurrencyCubit
class CurrencyState extends Equatable {
  final Currency currency;
  final bool isLoading;

  const CurrencyState({required this.currency, this.isLoading = false});

  CurrencyState copyWith({Currency? currency, bool? isLoading}) {
    return CurrencyState(
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [currency, isLoading];
}

/// Cubit for managing currency symbol selection
class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository _currencyRepository;

  CurrencyCubit(this._currencyRepository)
    : super(CurrencyState(currency: Currency.usd)) {
    _loadCurrency();
  }

  /// Load the saved currency from repository
  Future<void> _loadCurrency() async {
    emit(state.copyWith(isLoading: true));

    try {
      final savedCurrency = await _currencyRepository.getSavedCurrency();
      if (savedCurrency != null) {
        emit(CurrencyState(currency: savedCurrency));
      } else {
        // If no saved currency, default to USD
        emit(CurrencyState(currency: Currency.usd));
      }
    } catch (e) {
      // If there's an error loading, default to USD
      emit(CurrencyState(currency: Currency.usd));
    }
  }

  /// Change the currency symbol
  Future<void> changeCurrency(Currency currency) async {
    if (state.currency == currency) return;

    emit(state.copyWith(isLoading: true));

    try {
      await _currencyRepository.saveCurrency(currency);
      emit(CurrencyState(currency: currency));
    } catch (e) {
      // If saving fails, still update the state but log the error
      emit(CurrencyState(currency: currency));
    }
  }

  /// Get the current currency
  Currency get currentCurrency => state.currency;

  /// Get the currency symbol
  String get currentCurrencySymbol => state.currency.symbol;

  /// Get the display name of the current currency
  String get currentCurrencyDisplayName => state.currency.fullName;
}
