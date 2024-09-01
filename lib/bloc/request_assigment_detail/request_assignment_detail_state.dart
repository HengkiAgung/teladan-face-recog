// ignore_for_file: must_be_immutable

part of 'request_assignment_detail_bloc.dart';

class RequestAssignmentDetailState extends Equatable {
  const RequestAssignmentDetailState();
  
  @override
  List<Object> get props => [];
}

class RequestAssignmentDetailInitial extends RequestAssignmentDetailState {}

class RequestAssignmentDetailLoading extends RequestAssignmentDetailState {}

class RequestAssignmentDetailFetchNew extends RequestAssignmentDetailState {}

class RequestAssignmentDetailLoadSuccess extends RequestAssignmentDetailState {
  late List assignment;

  RequestAssignmentDetailLoadSuccess(this.assignment);
}

class RequestAssignmentDetailLoadFailure extends RequestAssignmentDetailState {
  final String error;

  const RequestAssignmentDetailLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load assignment {error: $error}';
  }
}