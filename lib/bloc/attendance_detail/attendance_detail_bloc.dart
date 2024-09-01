import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Attendance.dart';
import '../../repositories/attendance_repository.dart';
import '../../utils/auth.dart';

part 'attendance_detail_event.dart';
part 'attendance_detail_state.dart';

class AttendanceDetailBloc extends Bloc<AttendanceDetailEvent, AttendanceDetailState> {
  AttendanceDetailBloc() : super(AttendanceDetailInitial()) {
    on<GetAttendanceDetail>((event, emit) async {
      emit(AttendanceDetailLoading());
      try {
        String token = await Auth().getToken();

        final Attendance attendance = await AttendanceRepository().getAttendanceDetail(date: event.date, token: token,);

        emit(AttendanceDetailLoadSuccess(attendance));

      } catch (error) {
        emit(AttendanceDetailLoadFailure(error: error.toString()));
      }
    });
  }
}
