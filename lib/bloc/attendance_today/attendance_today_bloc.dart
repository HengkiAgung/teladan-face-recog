import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../models/Attendance.dart';
import '../../repositories/attendance_repository.dart';
import '../../utils/auth.dart';

part 'attendance_today_event.dart';
part 'attendance_today_state.dart';

class AttendanceTodayBloc extends Bloc<AttendanceTodayEvent, AttendanceTodayState> {
  AttendanceTodayBloc() : super(AttendanceTodayInitial()) {
    on<GetAttendanceToday>((event, emit) async {
      emit(AttendanceTodayLoading());
      try {
        String token = await Auth().getToken();

        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        final Attendance attendance = await AttendanceRepository().getAttendanceDetail(date: formattedDate, token: token);
        emit(AttendanceTodayLoadSuccess(attendance));

      } catch (error) {
        emit(AttendanceTodayLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(AttendanceTodayInitial());
    });
  }
}
