abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  final String userId;
  LoginSuccess(this.message, this.userId);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
