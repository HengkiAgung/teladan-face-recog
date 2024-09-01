import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Attendance/UserShiftRequest.dart';
import '../../repositories/request_repository.dart';
import '../../utils/auth.dart';

part 'request_shift_list_event.dart';
part 'request_shift_list_state.dart';

class RequestShiftListBloc
    extends Bloc<RequestShiftListEvent, RequestShiftListState> {
  RequestShiftListBloc() : super(RequestShiftListInitial()) {
    on<GetRequestList>((event, emit) async {
      emit(RequestShiftListLoading());
      try {
        String token = await Auth().getToken();

        final List<dynamic> rawData = await RequestRepository().getRequest(
            key: "userShiftRequest",
            type: "shift",
            model: UserShiftRequest(),
            token: token);
        final List<UserShiftRequest> castedData =
            rawData.cast<UserShiftRequest>();

        emit(RequestShiftListLoadSuccess(request: castedData));
      } catch (error) {
        emit(RequestShiftListLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<UserShiftRequest> requestList = [];
      final currentState = state;

      if (currentState is RequestShiftListLoadSuccess) {
        requestList.addAll(currentState.request);
      }

      emit(RequestShiftListFetchNew());

      try {
        String token = await Auth().getToken();

        final List<dynamic> request = await RequestRepository().getRequest(
            page: event.page.toString(),
            key: "userShiftRequest",
            type: "shift",
            model: UserShiftRequest(),
            token: token);

        requestList.addAll(request.cast<UserShiftRequest>());

        emit(RequestShiftListLoadSuccess(request: requestList));
      } catch (error) {
        emit(RequestShiftListLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(RequestShiftListInitial());
    });
  }
}
