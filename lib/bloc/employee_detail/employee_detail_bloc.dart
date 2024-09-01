import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:teladan/models/Employee/User.dart';
import 'package:teladan/repositories/employee_repository.dart';
import 'package:teladan/utils/auth.dart';

part 'employee_detail_event.dart';
part 'employee_detail_state.dart';

class EmployeeDetailBloc extends Bloc<EmployeeDetailEvent, EmployeeDetailState> {
  EmployeeDetailBloc() : super(EmployeeDetailInitial()) {
    on<GetEmployeeDetail>((event, emit) async {
      emit(EmployeeDetailLoading());
      try {
        String token = await Auth().getToken();

        final User employee = await EmployeeRepository().getDetailEmployee(token: token, id: event.id);

        emit(EmployeeDetailLoadSuccess(employee));

      } catch (error) {
        emit(EmployeeDetailLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(EmployeeDetailInitial());
    });
  }
}
