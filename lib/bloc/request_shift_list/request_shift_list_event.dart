part of 'request_shift_list_bloc.dart';

class RequestShiftListEvent extends Equatable {
  const RequestShiftListEvent();

  @override
  List<Object> get props => [];
}

class GetRequestList extends RequestShiftListEvent {}

class ScrollFetch extends RequestShiftListEvent {
  final int page;

  const ScrollFetch({required this.page});
}

class LogOut extends RequestShiftListEvent {}
