part of 'attendance_log_bloc.dart';

class AttendanceLogState extends Equatable {
  const AttendanceLogState();
  
  @override
  List<Object> get props => [];
}

class AttendanceLogInitial extends AttendanceLogState {}

class AttendanceLogLoading extends AttendanceLogState {}

class AttendanceLogFetchNew extends AttendanceLogState {}

class AttendanceLogLoadSuccess extends AttendanceLogState {
  final List<Attendance> attendance;

  const AttendanceLogLoadSuccess(this.attendance);
}

class AttendanceLogLoadFailure extends AttendanceLogState {
  final String error;

  const AttendanceLogLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load attendance {error: $error}';
  }
}