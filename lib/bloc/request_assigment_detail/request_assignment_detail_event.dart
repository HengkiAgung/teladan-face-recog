// ignore_for_file: must_be_immutable

part of 'request_assignment_detail_bloc.dart';

class RequestAssignmentDetailEvent extends Equatable {
  const RequestAssignmentDetailEvent();

  @override
  List<Object> get props => [];
}

class GetRequestAssigmentDetail extends RequestAssignmentDetailEvent {
  late int id;
  
  GetRequestAssigmentDetail({required this.id});
}
