part of 'leave_history_bloc.dart';

class LeaveHistoryState extends Equatable {
  const LeaveHistoryState();
  
  @override
  List<Object> get props => [];
}

class LeaveHistoryInitial extends LeaveHistoryState {}

class LeaveHistoryLoading extends LeaveHistoryState {}

class LeaveHistoryFetchNew extends LeaveHistoryState {}

class LeaveHistoryLoadSuccess extends LeaveHistoryState {
  final List<UserLeaveHistory> userLeaveHistory;

  const LeaveHistoryLoadSuccess(this.userLeaveHistory);
}

class LeaveHistoryLoadFailure extends LeaveHistoryState {
  final String error;

  const LeaveHistoryLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load history {error: $error}';
  }
}