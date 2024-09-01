part of 'request_leave_list_bloc.dart';

class RequestLeaveListState extends Equatable {
  const RequestLeaveListState();
  
  @override
  List<Object> get props => [];
}

class RequestLeaveListInitial extends RequestLeaveListState {}

class RequestLeaveListLoading extends RequestLeaveListState {}

class RequestLeaveListFetchNew extends RequestLeaveListState {}

class RequestLeaveListLoadSuccess extends RequestLeaveListState {
  final List<UserLeaveRequest> request;

  const RequestLeaveListLoadSuccess(this.request);
}

class RequestLeaveListLoadFailure extends RequestLeaveListState {
  final String error;

  const RequestLeaveListLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load request {error: $error}';
  }
}
