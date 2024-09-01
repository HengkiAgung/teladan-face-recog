part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoadSuccess extends UserState {
  final User user;
  final String token;

  const UserLoadSuccess(this.user, this.token);
}

class UserLoadFailure extends UserState {
  final String error;

  const UserLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load account {error: $error}';
  }
}