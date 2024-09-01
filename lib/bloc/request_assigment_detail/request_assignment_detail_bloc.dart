import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/repositories/request_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'request_assignment_detail_event.dart';
part 'request_assignment_detail_state.dart';

class RequestAssignmentDetailBloc extends Bloc<RequestAssignmentDetailEvent, RequestAssignmentDetailState> {
  RequestAssignmentDetailBloc() : super(RequestAssignmentDetailInitial()) {
    on<GetRequestAssigmentDetail>((event, emit) async {
      emit(RequestAssignmentDetailLoading());
      try {
        String token = await Auth().getToken();

        final List data = await RequestRepository().getAssignmentRequestDetail(token: token, id: event.id);

        emit(RequestAssignmentDetailLoadSuccess(data));
      } catch (error) {
        emit(RequestAssignmentDetailLoadFailure(error: error.toString()));
      }
    });
  }
}
