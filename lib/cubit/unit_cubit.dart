import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otolog/repositories/unit_repository.dart';
import 'package:otolog/shared/constants/unit.dart';

/// Events for UnitCubit
abstract class UnitEvent {}

/// Event to change the distance unit
class UnitChanged extends UnitEvent {
  final DistanceUnit unit;

  UnitChanged(this.unit);
}

/// Event to load the saved unit
class UnitLoaded extends UnitEvent {}

/// State for UnitCubit
class UnitState extends Equatable {
  final DistanceUnit unit;
  final bool isLoading;

  const UnitState({required this.unit, this.isLoading = false});

  UnitState copyWith({DistanceUnit? unit, bool? isLoading}) {
    return UnitState(
      unit: unit ?? this.unit,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [unit, isLoading];
}

/// Cubit for managing distance unit selection
class UnitCubit extends Cubit<UnitState> {
  final UnitRepository _unitRepository;

  UnitCubit(this._unitRepository) : super(UnitState(unit: DistanceUnit.km)) {
    _loadUnit();
  }

  /// Load the saved unit from repository
  Future<void> _loadUnit() async {
    emit(state.copyWith(isLoading: true));

    try {
      final savedUnit = await _unitRepository.getSavedUnit();
      if (savedUnit != null) {
        emit(UnitState(unit: savedUnit));
      } else {
        // If no saved unit, default to kilometers
        emit(UnitState(unit: DistanceUnit.km));
      }
    } catch (e) {
      // If there's an error loading, default to kilometers
      emit(UnitState(unit: DistanceUnit.km));
    }
  }

  /// Change the distance unit
  Future<void> changeUnit(DistanceUnit unit) async {
    if (state.unit == unit) return;

    emit(state.copyWith(isLoading: true));

    try {
      await _unitRepository.saveUnit(unit);
      emit(UnitState(unit: unit));
    } catch (e) {
      // If saving fails, still update the state but log the error
      emit(UnitState(unit: unit));
    }
  }

  /// Get the current unit
  DistanceUnit get currentUnit => state.unit;

  /// Get the display name of the current unit
  String get currentUnitDisplayName => state.unit.displayName;
}
