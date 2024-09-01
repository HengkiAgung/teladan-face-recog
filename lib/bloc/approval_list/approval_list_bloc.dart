import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/approval_repository.dart';
import '../../utils/auth.dart';

part 'approval_list_event.dart';
part 'approval_list_state.dart';

class ApprovalListBloc extends Bloc<ApprovalListEvent, ApprovalListState> {
  ApprovalListBloc() : super(ApprovalListInitial()) {
    on<GetRequestList>((event, emit) async {
      emit(ApprovalListLoading());
      try {
        String token = await Auth().getToken();

        final List<dynamic> request = await ApprovalRepository().getRequest(key: event.key, type: event.type, model: event.model, token: token);

        emit(ApprovalListLoadSuccess(request));

      } catch (error) {
        emit(ApprovalListLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<dynamic> requestList = [];
      final currentState = state;

      if (currentState is ApprovalListLoadSuccess) {
        requestList.addAll(currentState.request);
      } 

      emit(ApprovalListFetchNew());

      try {
        String token = await Auth().getToken();

        final List<dynamic> request = await ApprovalRepository().getRequest(page: event.page.toString(), key: event.key, type: event.type, model: event.model, token: token);
        requestList.addAll(request);

        emit(ApprovalListLoadSuccess(requestList));

      } catch (error) {
        emit(ApprovalListLoadFailure(error: error.toString()));
      }
    });
  }
}
