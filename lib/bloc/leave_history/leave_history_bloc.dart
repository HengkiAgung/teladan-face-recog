import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/models/Leave/UserLeaveHistory.dart';
import 'package:teladan/repositories/leave_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'leave_history_event.dart';
part 'leave_history_state.dart';

class LeaveHistoryBloc extends Bloc<LeaveHistoryEvent, LeaveHistoryState> {
  LeaveHistoryBloc() : super(LeaveHistoryInitial()) {
    on<GetLeaveHistory>((event, emit) async {
      emit(LeaveHistoryLoading());
      try {
        String token = await Auth().getToken();

        final List<UserLeaveHistory> employee = await LeaveRepository().getLeaveHistory(token: token,);

        emit(LeaveHistoryLoadSuccess(employee));

      } catch (error) {
        emit(LeaveHistoryLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<UserLeaveHistory> requestList = [];
      final currentState = state;

      if (currentState is LeaveHistoryLoadSuccess) {
        requestList.addAll(currentState.userLeaveHistory);
      }

      emit(LeaveHistoryFetchNew());

      try {
        String token = await Auth().getToken();

        final List<UserLeaveHistory> request = await LeaveRepository().getLeaveHistory(
            page: event.page,
            token: token);
        requestList.addAll(request);

        emit(LeaveHistoryLoadSuccess(requestList));
        
      } catch (error) {
        emit(LeaveHistoryLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(LeaveHistoryInitial());
    });
  }
}
