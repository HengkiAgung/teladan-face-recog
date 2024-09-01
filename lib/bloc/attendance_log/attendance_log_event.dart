part of 'attendance_log_bloc.dart';

class AttendanceLogEvent extends Equatable {
  const AttendanceLogEvent();

  @override
  List<Object> get props => [];
}

class GetAttendanceLog extends AttendanceLogEvent {
  final int month;
  final int year;

  const GetAttendanceLog({required this.month, required this.year});
}

class ScrollFetch extends AttendanceLogEvent {
  final int page;

  const ScrollFetch({required this.page});
}

class LogOut extends AttendanceLogEvent {}