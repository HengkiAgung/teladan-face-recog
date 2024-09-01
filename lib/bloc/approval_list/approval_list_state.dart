part of 'approval_list_bloc.dart';

class ApprovalListState extends Equatable {
  const ApprovalListState();
  
  @override
  List<Object> get props => [];
}

class ApprovalListInitial extends ApprovalListState {}

class ApprovalListLoading extends ApprovalListState {}

class ApprovalListFetchNew extends ApprovalListState {}

class ApprovalListLoadSuccess extends ApprovalListState {
  final List<dynamic> request;

  const ApprovalListLoadSuccess(this.request);
}

class ApprovalListLoadFailure extends ApprovalListState {
  final String error;

  const ApprovalListLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load request {error: $error}';
  }
}