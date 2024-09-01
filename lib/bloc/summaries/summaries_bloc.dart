import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Summaries.dart';
import '../../repositories/attendance_repository.dart';
import '../../utils/auth.dart';

part 'summaries_event.dart';
part 'summaries_state.dart';

class SummariesBloc extends Bloc<SummariesEvent, SummariesState> {
  SummariesBloc() : super(SummariesInitial()) {
    on<GetAttendanceSummaries>((event, emit) async {
      emit(SummariesLoading());
      try {
        String token = await Auth().getToken();
        Summaries summaries = await AttendanceRepository().getSummaries(null, null, token);

        emit(SummariesLoadSuccess(summaries));
      } catch (error) {
        emit(SummariesLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(SummariesInitial());
    });
  }
}
