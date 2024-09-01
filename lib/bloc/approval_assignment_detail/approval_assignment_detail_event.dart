// ignore_for_file: must_be_immutable

part of 'approval_assignment_detail_bloc.dart';

class ApprovalAssignmentDetailEvent extends Equatable {
  const ApprovalAssignmentDetailEvent();

  @override
  List<Object> get props => [];
}

class GetRequestAssigmentDetail extends ApprovalAssignmentDetailEvent {
  late int id;
  
  GetRequestAssigmentDetail({required this.id});
}
