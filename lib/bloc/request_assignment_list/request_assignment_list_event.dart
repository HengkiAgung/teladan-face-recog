part of 'request_assignment_list_bloc.dart';

class RequestAssignmentListEvent extends Equatable {
  const RequestAssignmentListEvent();

  @override
  List<Object> get props => [];
}

class GetRequestAssigment extends RequestAssignmentListEvent {
  const GetRequestAssigment();
}

class ScrollFetch extends RequestAssignmentListEvent {
  final int page;

  const ScrollFetch({required this.page});
}

class LogOut extends RequestAssignmentListEvent {}