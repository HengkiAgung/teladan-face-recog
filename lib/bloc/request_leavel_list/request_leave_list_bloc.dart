import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Attendance/UserLeaveRequest.dart';
import '../../repositories/request_repository.dart';
import '../../utils/auth.dart';

part 'request_leave_list_event.dart';
part 'request_leave_list_state.dart';

class RequestLeaveListBloc extends Bloc<RequestLeaveListEvent, RequestLeaveListState> {
  RequestLeaveListBloc() : super(RequestLeaveListInitial()) {
    on<GetRequestList>((event, emit) async {
      emit(RequestLeaveListLoading());
      try {
        String token = await Auth().getToken();
        
        final List<dynamic> rawData = await RequestRepository().getRequest(key: "userLeaveRequest", type: "time-off", model: UserLeaveRequest(), token: token);
        final List<UserLeaveRequest> castedData = rawData.cast<UserLeaveRequest>();
        
        emit(RequestLeaveListLoadSuccess(castedData));
        
      } catch (error) {
        emit(RequestLeaveListLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<UserLeaveRequest> requestList = [];
      final currentState = state;

      if (currentState is RequestLeaveListLoadSuccess) {
        requestList.addAll(currentState.request);
      } 

      emit(RequestLeaveListFetchNew());

      try {
        String token = await Auth().getToken();

        final List<dynamic> request = await RequestRepository().getRequest(page: event.page.toString(), key: "userLeaveRequest", type: "time-off", model: UserLeaveRequest(), token: token);
        requestList.addAll(request.cast<UserLeaveRequest>());

        emit(RequestLeaveListLoadSuccess(requestList));
        
      } catch (error) {
        emit(RequestLeaveListLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(RequestLeaveListInitial());
    });
  }
}
