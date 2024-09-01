import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/repositories/approval_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'approval_assignment_list_event.dart';
part 'approval_assignment_list_state.dart';

class ApprovalAssignmentListBloc extends Bloc<ApprovalAssignmentListEvent, ApprovalAssignmentListState> {
  ApprovalAssignmentListBloc() : super(ApprovalAssignmentListInitial()) {
    on<GetApprovalAssigment>((event, emit) async {
      emit(ApprovalAssignmentListLoading());
      try {
        String token = await Auth().getToken();

        final List<Assignment> data = await ApprovalRepository().getAssignmentApproval(token: token);

        emit(ApprovalAssignmentListLoadSuccess(data));
      } catch (error) {
        emit(ApprovalAssignmentListLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<Assignment> requestList = [];
      final currentState = state;

      if (currentState is ApprovalAssignmentListLoadSuccess) {
        requestList.addAll(currentState.request);
      }

      emit(ApprovalAssignmentListFetchNew());

      try {
        String token = await Auth().getToken();

        final List<dynamic> request = await ApprovalRepository().getAssignmentApproval(page: event.page.toString(), token: token);
        requestList.addAll(request.cast<Assignment>());

        emit(ApprovalAssignmentListLoadSuccess(requestList));
        
      } catch (error) {
        emit(ApprovalAssignmentListLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(ApprovalAssignmentListInitial());
    });
  }
}
