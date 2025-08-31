import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/repository.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await repository.login(event.email, event.password);
        debugPrint(
            "User logged in: ${user.email} userId: ${user.id} userfirstName: ${user.firstName}");
        emit(LoginSuccess("Login Successful \u2705", user.id));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
