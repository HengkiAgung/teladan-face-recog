part of 'approval_assignment_list_bloc.dart';

class ApprovalAssignmentListState extends Equatable {
  const ApprovalAssignmentListState();
  
  @override
  List<Object> get props => [];
}
class ApprovalAssignmentListInitial extends ApprovalAssignmentListState {}

class ApprovalAssignmentListLoading extends ApprovalAssignmentListState {}

class ApprovalAssignmentListFetchNew extends ApprovalAssignmentListState {}

class ApprovalAssignmentListLoadSuccess extends ApprovalAssignmentListState {
  final List<Assignment> request;

  const ApprovalAssignmentListLoadSuccess(this.request);
}

class ApprovalAssignmentListLoadFailure extends ApprovalAssignmentListState {
  final String error;

  const ApprovalAssignmentListLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load assignment {error: $error}';
  }
}