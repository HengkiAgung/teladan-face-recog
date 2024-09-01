import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/repositories/leave_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'leave_quota_event.dart';
part 'leave_quota_state.dart';

class LeaveQuotaBloc extends Bloc<LeaveQuotaEvent, LeaveQuotaState> {
  LeaveQuotaBloc() : super(LeaveQuotaInitial()) {
    on<GetLeaveQuota>((event, emit) async {
      emit(LeaveQuotaLoading());
      try {
        String token = await Auth().getToken();
        final quota = await LeaveRepository().getLeaveQuota(token: token);

        emit(LeaveQuotaLoadSuccess(quota));
      } catch (error) {
        emit(LeaveQuotaLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(LeaveQuotaInitial());
    });
  }
}
