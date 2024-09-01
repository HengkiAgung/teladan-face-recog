part of 'attendance_detail_bloc.dart';

class AttendanceDetailEvent extends Equatable {
  const AttendanceDetailEvent();

  @override
  List<Object> get props => [];
}

class GetAttendanceDetail extends AttendanceDetailEvent {
  final String date;

  const GetAttendanceDetail({required this.date});
}