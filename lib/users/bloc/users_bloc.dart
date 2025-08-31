import 'dart:convert';

import 'package:chatting_app/utils/api_url.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../model/users_model.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersListEvent, UsersState> {
  final String loggedInUserId;

  UsersBloc({required this.loggedInUserId}) : super(UsersInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final response =
            await http.get(Uri.parse('${ApiUrl.baseUrl}/api/user/users'));

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          print("Decoded response: $decoded");

          if (decoded['users'] == null) {
            emit(UsersError(message: "No users found"));
            return;
          }

          List<dynamic> data = decoded['users'];

          List<Users> users = data
              .map((e) => Users.fromJson(e as Map<String, dynamic>))
              .toList();

          users.removeWhere((user) => user.id == loggedInUserId);

          emit(UsersLoaded(users: users));
        } else {
          emit(UsersError(message: 'Failed to load users'));
        }
      } catch (e) {
        emit(UsersError(message: e.toString()));
      }
    });
  }
}
