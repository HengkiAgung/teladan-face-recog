import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Employee/User.dart';
import '../../repositories/user_repository.dart';
import '../../utils/auth.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetUser>((event, emit) async {
      emit(UserLoading());
      try {
        String token = await Auth().getToken();

        final User user = await UserRepository().getUser(token);
        emit(UserLoadSuccess(user, token));
      } catch (error) {
        emit(UserLoadFailure(error: error.toString()));
      }
    });
  }
}
