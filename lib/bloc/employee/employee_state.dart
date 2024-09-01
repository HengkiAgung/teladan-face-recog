part of 'employee_bloc.dart';

class EmployeeState extends Equatable {
  const EmployeeState();
  
  @override
  List<Object> get props => [];
}


class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeFetchNew extends EmployeeState {}

class EmployeeLoadSuccess extends EmployeeState {
  final List<User> employee;

  const EmployeeLoadSuccess(this.employee);
}

class EmployeeLoadFailure extends EmployeeState {
  final String error;

  const EmployeeLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load employee {error: $error}';
  }
}