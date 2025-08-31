import 'package:chatting_app/chat_screen/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatting_app/utils/helper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat_screen/view/chat_screen.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';


class UserScreen extends StatefulWidget {
  final String loggedInUserId;
  const UserScreen({super.key, required this.loggedInUserId});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late UsersBloc usersBloc;

  @override
  void initState() {
    super.initState();

    print("id of logged in user: ${widget.loggedInUserId}");
    usersBloc = UsersBloc(loggedInUserId: widget.loggedInUserId);

    usersBloc.add(FetchUsers());
  }

  @override
  void dispose() {
    usersBloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    usersBloc.add(FetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            onPressed: () {
              Helper.logout(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: BlocProvider.value(
        value: usersBloc,
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UsersLoaded) {
              if (state.users.isEmpty) {
                return const Center(child: Text("No users found"));
              }
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300, // हल्की लाइन नीचे
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => ChatBloc(),
                                child: ChatScreen(
                                  user: user,
                                  loggedInUserId:
                                      widget.loggedInUserId.toString(),
                                ),
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.withOpacity(0.8),
                          child: const Icon(Icons.person),
                        ),
                        title: Text('${user.name}'),
                        subtitle: Text(user.email.toString()),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                      ),
                    );
                  },
                ),
              );
            } else if (state is UsersError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No users found'));
          },
        ),
      ),
    );
  }
}
