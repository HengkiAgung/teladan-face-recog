import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/models/Employee/WorkingShift.dart';
import 'package:teladan/repositories/request_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'current_shift_event.dart';
part 'current_shift_state.dart';

class CurrentShiftBloc extends Bloc<CurrentShiftEvent, CurrentShiftState> {
  CurrentShiftBloc() : super(CurrentShiftInitial()) {
    on<GetCurrentShift>((event, emit) async {
      emit(CurrentShiftLoading());
      try {
        String token = await Auth().getToken();

        final WorkingShift workingShift = await RequestRepository().getCurrentShift(token: token);
        emit(CurrentShiftLoadSuccess(workingShift));

      } catch (error) {
        emit(CurrentShiftLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(CurrentShiftInitial());
    });
  }
}
