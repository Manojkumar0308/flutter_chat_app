abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  SignUpSubmitted(this.name, this.email, this.password);
}
