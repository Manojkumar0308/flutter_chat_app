import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../signup_event/signup_event.dart';
import '../signup_states/signup_states.dart';


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignupApiService authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    if (event.name.isEmpty || event.email.isEmpty || event.password.isEmpty) {
      emit(SignUpFailure("All fields are required"));
      return;
    }

    if (!event.email.contains("@")) {
      emit(SignUpFailure("Invalid email format"));
      return;
    }

    emit(SignUpLoading());

    try {
      final user = await authRepository.registerUser(event.name, event.email, event.password);
      emit(SignUpSuccess("User registered successfully: ${user.email}"));
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}
