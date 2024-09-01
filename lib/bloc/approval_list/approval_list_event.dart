part of 'approval_list_bloc.dart';

class ApprovalListEvent extends Equatable {
  const ApprovalListEvent();

  @override
  List<Object> get props => [];
}

class GetRequestList extends ApprovalListEvent {
  final String key;
  final String type;
  final dynamic model;

  const GetRequestList({required this.key, required this.type, required this.model});
}

class ScrollFetch extends ApprovalListEvent {
  final int page;
  final String key;
  final String type;
  final dynamic model;

  const ScrollFetch({required this.page, required this.key, required this.type, required this.model});
}