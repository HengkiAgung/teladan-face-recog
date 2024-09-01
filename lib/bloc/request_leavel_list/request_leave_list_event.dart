part of 'request_leave_list_bloc.dart';

class RequestLeaveListEvent extends Equatable {
  const RequestLeaveListEvent();

  @override
  List<Object> get props => [];
}

class GetRequestList extends RequestLeaveListEvent {
  const GetRequestList();
}

class ScrollFetch extends RequestLeaveListEvent {
  final int page;

  const ScrollFetch({required this.page});
}

class LogOut extends RequestLeaveListEvent {}