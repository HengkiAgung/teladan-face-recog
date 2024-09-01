part of 'employee_detail_bloc.dart';

class EmployeeDetailState extends Equatable {
  const EmployeeDetailState();
  
  @override
  List<Object> get props => [];
}

class EmployeeDetailInitial extends EmployeeDetailState {}

class EmployeeDetailLoading extends EmployeeDetailState {}

class EmployeeDetailFetchNew extends EmployeeDetailState {}

class EmployeeDetailLoadSuccess extends EmployeeDetailState {
  final User employee;

  const EmployeeDetailLoadSuccess(this.employee);
}

class EmployeeDetailLoadFailure extends EmployeeDetailState {
  final String error;

  const EmployeeDetailLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load employee {error: $error}';
  }
}