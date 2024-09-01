part of 'current_shift_bloc.dart';

class CurrentShiftEvent extends Equatable {
  const CurrentShiftEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentShift extends CurrentShiftEvent {}

class LogOut extends CurrentShiftEvent {}