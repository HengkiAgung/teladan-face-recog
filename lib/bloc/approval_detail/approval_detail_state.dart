part of 'approval_detail_bloc.dart';

class ApprovalDetailState extends Equatable {
  const ApprovalDetailState();
  
  @override
  List<Object> get props => [];
}

class ApprovalDetailInitial extends ApprovalDetailState {}

class ApprovalDetailLoading extends ApprovalDetailState {}

class ApprovalDetailLoadSuccess extends ApprovalDetailState {
  final dynamic request;

  const ApprovalDetailLoadSuccess(this.request);
}

class ApprovalDetailLoadFailure extends ApprovalDetailState {
  final String error;

  const ApprovalDetailLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load detail {error: $error}';
  }
}