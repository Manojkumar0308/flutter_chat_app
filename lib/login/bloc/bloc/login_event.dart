abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;

  LoginRequested({required this.email,  required this.password});
}

class LoginId extends LoginEvent {
  final String id;

  LoginId(this.id);
}
