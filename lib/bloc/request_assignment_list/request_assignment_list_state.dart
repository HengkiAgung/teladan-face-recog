part of 'request_assignment_list_bloc.dart';

class RequestAssignmentListState extends Equatable {
  const RequestAssignmentListState();
  
  @override
  List<Object> get props => [];
}

class RequestAssignmentListInitial extends RequestAssignmentListState {}

class RequestAssignmentListLoading extends RequestAssignmentListState {}

class RequestAssignmentListFetchNew extends RequestAssignmentListState {}

class RequestAssignmentListLoadSuccess extends RequestAssignmentListState {
  final List<Assignment> request;

  const RequestAssignmentListLoadSuccess(this.request);
}

class RequestAssignmentListLoadFailure extends RequestAssignmentListState {
  final String error;

  const RequestAssignmentListLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load assignment {error: $error}';
  }
}
