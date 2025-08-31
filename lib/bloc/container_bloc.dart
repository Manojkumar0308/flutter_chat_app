import 'package:flutter_bloc/flutter_bloc.dart';

import 'container_event.dart';
import 'container_state.dart';

class ContainerBloc extends Bloc<ContainerEvent, ContainerState> {
  ContainerBloc() : super(LoginState()) {
    on<SwitchToLoginEvent>((event, emit) {
      emit(LoginState());
    });

    on<SwitchToSignUpEvent>((event, emit) {
      emit(SignUpState());
    });
  }
}