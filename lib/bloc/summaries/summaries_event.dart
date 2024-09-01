part of 'summaries_bloc.dart';

class SummariesEvent extends Equatable {
  const SummariesEvent();

  @override
  List<Object> get props => [];
}

class GetAttendanceSummaries extends SummariesEvent {}

class LogOut extends SummariesEvent {}