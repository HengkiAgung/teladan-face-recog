import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Attendance.dart';
import '../../repositories/attendance_repository.dart';
import '../../utils/auth.dart';

part 'attendance_log_event.dart';
part 'attendance_log_state.dart';

class AttendanceLogBloc extends Bloc<AttendanceLogEvent, AttendanceLogState> {
  AttendanceLogBloc() : super(AttendanceLogInitial()) {
    on<GetAttendanceLog>((event, emit) async {
      emit(AttendanceLogLoading());

      try {
        String token = await Auth().getToken();

        final List<Attendance> attendanceList = await AttendanceRepository().getHistoryAttendance(token: token, month: event.month, year: event.year);

        emit(AttendanceLogLoadSuccess(attendanceList));

      } catch (error) {
        emit(AttendanceLogLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<Attendance> attendanceList = [];
      final currentState = state;

      if (currentState is AttendanceLogLoadSuccess) {
        attendanceList.addAll(currentState.attendance);
      } 

      emit(AttendanceLogFetchNew());

      try {
        String token = await Auth().getToken();

        final List<Attendance> newAttendanceList = await AttendanceRepository().getHistoryAttendance(token: token, page: event.page.toString());
        attendanceList.addAll(newAttendanceList);

        emit(AttendanceLogLoadSuccess(attendanceList));

      } catch (error) {
        emit(AttendanceLogLoadFailure(error: error.toString()));
      }
    });
    
    on<LogOut>((event, emit) async {
      emit(AttendanceLogInitial());
    });
  }
}
