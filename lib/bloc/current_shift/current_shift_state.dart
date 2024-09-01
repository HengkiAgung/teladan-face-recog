part of 'current_shift_bloc.dart';

class CurrentShiftState extends Equatable {
  const CurrentShiftState();
  
  @override
  List<Object> get props => [];
}
 
class CurrentShiftInitial extends CurrentShiftState {}

class CurrentShiftLoading extends CurrentShiftState {}

class CurrentShiftLoadSuccess extends CurrentShiftState {
  final WorkingShift workingShift;

  const CurrentShiftLoadSuccess(this.workingShift);
}

class CurrentShiftLoadFailure extends CurrentShiftState {
  final String error;

  const CurrentShiftLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load attendance {error: $error}';
  }
}