import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/repositories/notification_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'notification_badge_event.dart';
part 'notification_badge_state.dart';

class NotificationBadgeBloc extends Bloc<NotificationBadgeEvent, NotificationBadgeState> {
  NotificationBadgeBloc() : super(NotificationBadgeInitial()) {
    on<GetAllNotification>((event, emit) async {
      emit(NotificationBadgeLoading());
      try {
        String token = await Auth().getToken();
        int attendance = await NotificationRepository().getAttendanceNotifications(token: token);
        int shift = await NotificationRepository().getShiftNotifications(token: token);
        int timeOff = await NotificationRepository().getTimeOffNotifications(token: token);
        int assignment = await NotificationRepository().getAssignmentNotifications(token: token);
        int total = attendance + shift + timeOff + assignment;

        emit(NotificationBadgeLoadSuccess(assignment: assignment, attendance: attendance, shift: shift, timeoff: timeOff, total: total));
      } catch (error) {
        emit(NotificationBadgeLoadFailure(error: error.toString()));
      }
    });
    on<UpdateAttendanceNotification>((event, emit) async {
      int total = 0;
      int assignment = 0;
      int shift = 0;
      int timeOff = 0;

      final currentState = state;
      if (currentState is NotificationBadgeLoadSuccess) {
        total = currentState.total - currentState.attendance;
        assignment = currentState.assignment;
        shift = currentState.shift;
        timeOff = currentState.timeoff;
      } 
      
      emit(NotificationBadgeLoading());
      try {
        String token = await Auth().getToken();

        int attendance = await NotificationRepository().getAttendanceNotifications(token: token);
        total += attendance;

        emit(NotificationBadgeLoadSuccess(assignment: assignment, attendance: attendance, shift: shift, timeoff: timeOff, total: total));
      } catch (error) {
        emit(NotificationBadgeLoadFailure(error: error.toString()));
      }
    });

    on<UpdateShiftNotification>((event, emit) async {
      int total = 0;
      int assignment = 0;
      int attendance = 0;
      int timeOff = 0;

      final currentState = state;
      if (currentState is NotificationBadgeLoadSuccess) {
        total = currentState.total - currentState.shift;
        assignment = currentState.assignment;
        attendance = currentState.attendance;
        timeOff = currentState.timeoff;
      } 
      
      emit(NotificationBadgeLoading());
      try {
        String token = await Auth().getToken();

        int shift = await NotificationRepository().getShiftNotifications(token: token);
        total += shift;

        emit(NotificationBadgeLoadSuccess(assignment: assignment, attendance: attendance, shift: shift, timeoff: timeOff, total: total));
      } catch (error) {
        emit(NotificationBadgeLoadFailure(error: error.toString()));
      }
    });
    
    on<UpdateTimeOffNotification>((event, emit) async {
      int total = 0;
      int assignment = 0;
      int attendance = 0;
      int shift = 0;

      final currentState = state;
      if (currentState is NotificationBadgeLoadSuccess) {
        total = currentState.total - currentState.timeoff;
        assignment = currentState.assignment;
        attendance = currentState.attendance;
        shift = currentState.shift;
      } 
      
      emit(NotificationBadgeLoading());
      try {
        String token = await Auth().getToken();

        int timeOff = await NotificationRepository().getTimeOffNotifications(token: token);
        total += timeOff;

        emit(NotificationBadgeLoadSuccess(assignment: assignment, attendance: attendance, shift: shift, timeoff: timeOff, total: total));
      } catch (error) {
        emit(NotificationBadgeLoadFailure(error: error.toString()));
      }
    });
    
    on<UpdateAssignmetNotification>((event, emit) async {
      int total = 0;
      int attendance = 0;
      int shift = 0;
      int timeOff = 0;

      final currentState = state;
      if (currentState is NotificationBadgeLoadSuccess) {
        total = currentState.total - currentState.assignment;
        attendance = currentState.attendance;
        shift = currentState.shift;
        timeOff = currentState.timeoff;
      } 
      
      emit(NotificationBadgeLoading());
      try {
        String token = await Auth().getToken();

        int assignment = await NotificationRepository().getAssignmentNotifications(token: token);
        total += assignment;

        emit(NotificationBadgeLoadSuccess(assignment: assignment, attendance: attendance, shift: shift, timeoff: timeOff, total: total));
      } catch (error) {
        emit(NotificationBadgeLoadFailure(error: error.toString()));
      }
    });
    
    on<LogOut>((event, emit) {
      emit(NotificationBadgeInitial());
    });
  }
}
