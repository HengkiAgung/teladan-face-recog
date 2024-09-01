part of 'attendance_detail_bloc.dart';

class AttendanceDetailState extends Equatable {
  const AttendanceDetailState();
  
  @override
  List<Object> get props => [];
}

class AttendanceDetailInitial extends AttendanceDetailState {}

class AttendanceDetailLoading extends AttendanceDetailState {}

class AttendanceDetailLoadSuccess extends AttendanceDetailState {
  final Attendance attendance;

  const AttendanceDetailLoadSuccess(this.attendance);
}

class AttendanceDetailLoadFailure extends AttendanceDetailState {
  final String error;

  const AttendanceDetailLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load attendance {error: $error}';
  }
}