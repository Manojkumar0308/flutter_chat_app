import '../model/users_model.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<Users> users;
  UsersLoaded({required this.users});
}

class UsersError extends UsersState {
  final String message;
  UsersError({required this.message});
}
