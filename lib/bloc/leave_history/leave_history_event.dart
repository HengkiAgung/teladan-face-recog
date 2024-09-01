part of 'leave_history_bloc.dart';

class LeaveHistoryEvent extends Equatable {
  const LeaveHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetLeaveHistory extends LeaveHistoryEvent {}

class ScrollFetch extends LeaveHistoryEvent {
  final int page;

  const ScrollFetch({required this.page});
}

class LogOut extends LeaveHistoryEvent {}
