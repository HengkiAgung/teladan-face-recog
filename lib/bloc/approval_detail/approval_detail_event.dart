part of 'approval_detail_bloc.dart';

class ApprovalDetailEvent extends Equatable {
  const ApprovalDetailEvent();

  @override
  List<Object> get props => [];
}

class GetRequestDetail extends ApprovalDetailEvent {
  final String id;
  final String type;
  final dynamic model;

  const GetRequestDetail({required this.id, required this.type, required this.model});
}
