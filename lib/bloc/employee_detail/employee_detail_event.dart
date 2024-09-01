part of 'employee_detail_bloc.dart';

class EmployeeDetailEvent extends Equatable {
  const EmployeeDetailEvent();

  @override
  List<Object> get props => [];
}

class GetEmployeeDetail extends EmployeeDetailEvent {
  final String id;

  const GetEmployeeDetail({required this.id});
}

class LogOut extends EmployeeDetailEvent {}