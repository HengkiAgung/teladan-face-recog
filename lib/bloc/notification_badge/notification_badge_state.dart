// ignore_for_file: must_be_immutable

part of 'notification_badge_bloc.dart';

class NotificationBadgeState extends Equatable {
  const NotificationBadgeState();
  
  @override
  List<Object> get props => [];
}

class NotificationBadgeInitial extends NotificationBadgeState {}

class NotificationBadgeLoading extends NotificationBadgeState {}

class NotificationBadgeFetchNew extends NotificationBadgeState {}

class NotificationBadgeLoadSuccess extends NotificationBadgeState {
  late int total;
  late int attendance;
  late int shift;
  late int timeoff;
  late int assignment;

  NotificationBadgeLoadSuccess({required this.assignment, required this.attendance, required this.shift, required this.timeoff, required this.total});
}

class NotificationBadgeLoadFailure extends NotificationBadgeState {
  final String error;

  const NotificationBadgeLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load assignment {error: $error}';
  }
}