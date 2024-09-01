part of 'attendance_today_bloc.dart';

class AttendanceTodayEvent extends Equatable {
  const AttendanceTodayEvent();

  @override
  List<Object> get props => [];
}

class GetAttendanceToday extends AttendanceTodayEvent {}

class LogOut extends AttendanceTodayEvent {}
