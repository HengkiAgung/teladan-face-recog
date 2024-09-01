part of 'employee_bloc.dart';

class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class GetEmployee extends EmployeeEvent {
  final String name;

  const GetEmployee({required this.name});
}

class LogOut extends EmployeeEvent {}

class ScrollFetch extends EmployeeEvent {
  final String name;
  final int page;

  const ScrollFetch({required this.page, required this.name});
}