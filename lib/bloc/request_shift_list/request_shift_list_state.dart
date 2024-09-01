part of 'request_shift_list_bloc.dart';

class RequestShiftListState extends Equatable {
  const RequestShiftListState();
  
  @override
  List<Object> get props => [];
}

class RequestShiftListInitial extends RequestShiftListState {}

class RequestShiftListLoading extends RequestShiftListState {}

class RequestShiftListFetchNew extends RequestShiftListState {}

class RequestShiftListLoadSuccess extends RequestShiftListState {
  final List<UserShiftRequest> request;

  const RequestShiftListLoadSuccess({required this.request});
}

class RequestShiftListLoadFailure extends RequestShiftListState {
  final String error;

  const RequestShiftListLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load shift request {error: $error}';
  }
}