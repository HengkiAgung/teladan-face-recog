part of 'request_detail_bloc.dart';

class RequestDetailState extends Equatable {
  const RequestDetailState();
  
  @override
  List<Object> get props => [];
}


class RequestDetailInitial extends RequestDetailState {}

class RequestDetailLoading extends RequestDetailState {}

class RequestDetailLoadSuccess extends RequestDetailState {
  final dynamic request;

  const RequestDetailLoadSuccess(this.request);
}

class RequestDetailLoadFailure extends RequestDetailState {
  final String error;

  const RequestDetailLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load detail request {error: $error}';
  }
}