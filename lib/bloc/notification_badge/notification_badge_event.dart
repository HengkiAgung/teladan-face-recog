part of 'notification_badge_bloc.dart';

class NotificationBadgeEvent extends Equatable {
  const NotificationBadgeEvent();

  @override
  List<Object> get props => [];
}

class GetAllNotification extends NotificationBadgeEvent {}

class UpdateAttendanceNotification extends NotificationBadgeEvent {}

class UpdateShiftNotification extends NotificationBadgeEvent {}

class UpdateTimeOffNotification extends NotificationBadgeEvent {}

class UpdateAssignmetNotification extends NotificationBadgeEvent {}

class LogOut extends NotificationBadgeEvent {}