part of 'approval_assignment_list_bloc.dart';

class ApprovalAssignmentListEvent extends Equatable {
  const ApprovalAssignmentListEvent();

  @override
  List<Object> get props => [];
}

class GetApprovalAssigment extends ApprovalAssignmentListEvent {
  const GetApprovalAssigment();
}

class ScrollFetch extends ApprovalAssignmentListEvent {
  final int page;

  const ScrollFetch({required this.page});
}

class LogOut extends ApprovalAssignmentListEvent {}