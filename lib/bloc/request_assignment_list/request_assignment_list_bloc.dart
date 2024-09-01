import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/repositories/request_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'request_assignment_list_event.dart';
part 'request_assignment_list_state.dart';

class RequestAssignmentListBloc extends Bloc<RequestAssignmentListEvent, RequestAssignmentListState> {
  RequestAssignmentListBloc() : super(RequestAssignmentListInitial()) {
    on<GetRequestAssigment>((event, emit) async {
      emit(RequestAssignmentListLoading());
      try {
        String token = await Auth().getToken();

        final List<Assignment> data = await RequestRepository().getAssignmentRequest(token: token);

        emit(RequestAssignmentListLoadSuccess(data));
      } catch (error) {
        emit(RequestAssignmentListLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<Assignment> requestList = [];
      final currentState = state;

      if (currentState is RequestAssignmentListLoadSuccess) {
        requestList.addAll(currentState.request);
      }

      emit(RequestAssignmentListFetchNew());

      try {
        String token = await Auth().getToken();

        final List<dynamic> request = await RequestRepository().getAssignmentRequest(page: event.page.toString(), token: token);
        requestList.addAll(request.cast<Assignment>());

        emit(RequestAssignmentListLoadSuccess(requestList));
        
      } catch (error) {
        emit(RequestAssignmentListLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(RequestAssignmentListInitial());
    });
  }
}
