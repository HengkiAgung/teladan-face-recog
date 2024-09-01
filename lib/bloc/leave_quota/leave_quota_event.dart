part of 'leave_quota_bloc.dart';

class LeaveQuotaEvent extends Equatable {
  const LeaveQuotaEvent();

  @override
  List<Object> get props => [];
}

class GetLeaveQuota extends LeaveQuotaEvent {}

class LogOut extends LeaveQuotaEvent {}