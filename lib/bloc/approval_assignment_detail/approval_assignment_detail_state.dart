// ignore_for_file: must_be_immutable

part of 'approval_assignment_detail_bloc.dart';

class ApprovalAssignmentDetailState extends Equatable {
  const ApprovalAssignmentDetailState();
  
  @override
  List<Object> get props => [];
}

class ApprovalAssignmentDetailInitial extends ApprovalAssignmentDetailState {}

class ApprovalAssignmentDetailLoading extends ApprovalAssignmentDetailState {}

class ApprovalAssignmentDetailFetchNew extends ApprovalAssignmentDetailState {}

class ApprovalAssignmentDetailLoadSuccess extends ApprovalAssignmentDetailState {
  late Assignment assignment;

  ApprovalAssignmentDetailLoadSuccess(this.assignment);
}

class ApprovalAssignmentDetailLoadFailure extends ApprovalAssignmentDetailState {
  final String error;

  const ApprovalAssignmentDetailLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load assignment {error: $error}';
  }
}