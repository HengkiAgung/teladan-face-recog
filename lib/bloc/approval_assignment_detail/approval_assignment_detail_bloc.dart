import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/repositories/approval_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'approval_assignment_detail_event.dart';
part 'approval_assignment_detail_state.dart';

class ApprovalAssignmentDetailBloc extends Bloc<ApprovalAssignmentDetailEvent, ApprovalAssignmentDetailState> {
  ApprovalAssignmentDetailBloc() : super(ApprovalAssignmentDetailInitial()) {
    on<GetRequestAssigmentDetail>((event, emit) async {
      emit(ApprovalAssignmentDetailLoading());
      try {
        String token = await Auth().getToken();

        final Assignment data = await ApprovalRepository().getAssignmentApprovalDetail(token: token, id: event.id);

        emit(ApprovalAssignmentDetailLoadSuccess(data));
      } catch (error) {
        emit(ApprovalAssignmentDetailLoadFailure(error: error.toString()));
      }
    });
  }
}
