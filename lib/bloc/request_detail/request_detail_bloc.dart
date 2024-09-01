import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/request_repository.dart';
import '../../utils/auth.dart';

part 'request_detail_event.dart';
part 'request_detail_state.dart';

class RequestDetailBloc extends Bloc<RequestDetailEvent, RequestDetailState> {
  RequestDetailBloc() : super(RequestDetailInitial()) {
    on<GetRequestDetail>((event, emit) async {
      emit(RequestDetailLoading());
      try {
        String token = await Auth().getToken();

        final attendance = await RequestRepository().getRequestDetail(id: event.id, type: event.type, model: event.model, token: token);

        emit(RequestDetailLoadSuccess(attendance));
      } catch (error) {
        emit(RequestDetailLoadFailure(error: error.toString()));
      }
    });
  }
}
