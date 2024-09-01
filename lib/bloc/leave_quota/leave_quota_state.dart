part of 'leave_quota_bloc.dart';

class LeaveQuotaState extends Equatable {
  const LeaveQuotaState();
  
  @override
  List<Object> get props => [];
}

class LeaveQuotaInitial extends LeaveQuotaState {}

class LeaveQuotaLoading extends LeaveQuotaState {}

class LeaveQuotaLoadSuccess extends LeaveQuotaState {
  final int quota;

  const LeaveQuotaLoadSuccess(this.quota);
}

class LeaveQuotaLoadFailure extends LeaveQuotaState {
  final String error;

  const LeaveQuotaLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load quota {error: $error}';
  }
}