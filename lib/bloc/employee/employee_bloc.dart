import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Employee/User.dart';
import '../../repositories/employee_repository.dart';
import '../../utils/auth.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    on<GetEmployee>((event, emit) async {
      emit(EmployeeLoading());
      try {
        String token = await Auth().getToken();
        print("name ${event.name}");

        final List<User> employee = await EmployeeRepository().getAllUser(token: token, name: event.name);

        emit(EmployeeLoadSuccess(employee));

      } catch (error) {
        emit(EmployeeLoadFailure(error: error.toString()));
      }
    });

    on<ScrollFetch>((event, emit) async {
      List<User> employeeList = [];
      final currentState = state;

      if (currentState is EmployeeLoadSuccess) {
        employeeList.addAll(currentState.employee);
      } 

      emit(EmployeeFetchNew());

      try {
        String token = await Auth().getToken();
        print("name ${event.name}");
        final List<User> newEmployeeList = await EmployeeRepository().getAllUser(token: token, page: event.page.toString(), name: event.name);
        employeeList.addAll(newEmployeeList);

        emit(EmployeeLoadSuccess(employeeList));

      } catch (error) {
        emit(EmployeeLoadFailure(error: error.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(EmployeeInitial());
    });
  }
}
