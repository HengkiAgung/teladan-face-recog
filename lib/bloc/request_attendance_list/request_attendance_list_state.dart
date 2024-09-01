part of 'request_attendance_list_bloc.dart';

class RequestAttendanceListState extends Equatable {
  const RequestAttendanceListState();
  
  @override
  List<Object> get props => [];
}

class RequestAttendanceListInitial extends RequestAttendanceListState {}

class RequestAttendanceListLoading extends RequestAttendanceListState {}

class RequestAttendanceListFetchNew extends RequestAttendanceListState {}

class RequestAttendanceListLoadSuccess extends RequestAttendanceListState {
  final List<UserAttendanceRequest> request;

  const RequestAttendanceListLoadSuccess(this.request);
}

class RequestAttendanceListLoadFailure extends RequestAttendanceListState {
  final String error;

  const RequestAttendanceListLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load attendance {error: $error}';
  }
}