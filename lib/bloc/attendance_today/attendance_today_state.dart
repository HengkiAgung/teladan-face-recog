part of 'attendance_today_bloc.dart';

class AttendanceTodayState extends Equatable {
  const AttendanceTodayState();
  
  @override
  List<Object> get props => [];
}

class AttendanceTodayInitial extends AttendanceTodayState {}

class AttendanceTodayLoading extends AttendanceTodayState {}

class AttendanceTodayLoadSuccess extends AttendanceTodayState {
  final Attendance attendance;

  const AttendanceTodayLoadSuccess(this.attendance);
}

class AttendanceTodayLoadFailure extends AttendanceTodayState {
  final String error;

  const AttendanceTodayLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load attendance {error: $error}';
  }
}