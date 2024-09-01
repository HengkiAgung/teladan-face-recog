import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Attendance/UserAttendanceRequest.dart';
import '../../repositories/request_repository.dart';
import '../../utils/auth.dart';

part 'request_attendance_list_event.dart';
part 'request_attendance_list_state.dart';

class RequestAttendanceListBloc
    extends Bloc<RequestAttendanceListEvent, RequestAttendanceListState> {
  RequestAttendanceListBloc() : super(RequestAttendanceListInitial()) {
    on<GetRequestList>((event, emit) async {
      emit(RequestAttendanceListLoading());
      try {
        String token = await Auth().getToken();

        final List<dynamic> rawData = await RequestRepository().getRequest(
            key: "userAttendanceRequest",
            type: "attendance",
            model: UserAttendanceRequest(),
            token: token);
        final List<UserAttendanceRequest> castedData =
            rawData.cast<UserAttendanceRequest>();

        emit(RequestAttendanceListLoadSuccess(castedData));
      } catch (error) {
        emit(RequestAttendanceListLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<UserAttendanceRequest> requestList = [];
      final currentState = state;

      if (currentState is RequestAttendanceListLoadSuccess) {
        requestList.addAll(currentState.request);
      }

      emit(RequestAttendanceListFetchNew());

      try {
        String token = await Auth().getToken();

        final List<dynamic> request = await RequestRepository().getRequest(
            page: event.page.toString(),
            key: "userAttendanceRequest",
            type: "attendance",
            model: UserAttendanceRequest(),
            token: token);
        requestList.addAll(request.cast<UserAttendanceRequest>());

        emit(RequestAttendanceListLoadSuccess(requestList));
        
      } catch (error) {
        emit(RequestAttendanceListLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(RequestAttendanceListInitial());
    });
  }
}
