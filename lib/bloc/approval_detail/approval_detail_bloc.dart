import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/approval_repository.dart';
import '../../utils/auth.dart';

part 'approval_detail_event.dart';
part 'approval_detail_state.dart';

class ApprovalDetailBloc extends Bloc<ApprovalDetailEvent, ApprovalDetailState> {
  ApprovalDetailBloc() : super(ApprovalDetailInitial()) {
    on<GetRequestDetail>((event, emit) async {
      emit(ApprovalDetailLoading());
      try {
        String token = await Auth().getToken();

        final request = await ApprovalRepository().getDetailRequest(id: event.id, type: event.type, model: event.model, token: token);

        emit(ApprovalDetailLoadSuccess(request));

      } catch (error) {
        emit(ApprovalDetailLoadFailure(error: error.toString()));
      }
    });
  }
}
