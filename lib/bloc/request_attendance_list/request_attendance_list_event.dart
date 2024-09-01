part of 'request_attendance_list_bloc.dart';

class RequestAttendanceListEvent extends Equatable {
  const RequestAttendanceListEvent();

  @override
  List<Object> get props => [];
}

class GetRequestList extends RequestAttendanceListEvent {
  const GetRequestList();
}

class ScrollFetch extends RequestAttendanceListEvent {
  final int page;

  const ScrollFetch({required this.page});
}

class LogOut extends RequestAttendanceListEvent {}