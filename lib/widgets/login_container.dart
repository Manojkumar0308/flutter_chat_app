import 'package:chatting_app/login/bloc/bloc/login_bloc.dart';
import 'package:chatting_app/login/bloc/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/container_bloc.dart';
import '../bloc/container_event.dart';
import '../login/bloc/bloc/login_event.dart';
import '../users/view/users_list.dart';

class LoginContainer extends StatefulWidget {
  LoginContainer({super.key});
 
  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  void _onLoginPressed(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      context
          .read<LoginBloc>()
          .add(LoginRequested(email: email, password: password));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.15), shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              cursorWidth: 1.2,
              cursorColor: Colors.black,
              cursorHeight: 16,
              decoration: InputDecoration(
                hintText: "Email",
                contentPadding: const EdgeInsets.only(
                  top: 2.0,
                  bottom: 2.0,
                  left: 10.0,
                  right: 10.0,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    top: 2.0,
                    bottom: 2.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  focusedBorder: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ))),
            ),
            const SizedBox(height: 30),
            BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                } else if (state is LoginSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserScreen(loggedInUserId: state.userId),
                    ),
                  );
                }
              },
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  }

                  return ElevatedButton(
                    onPressed: () => _onLoginPressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    context.read<ContainerBloc>().add(SwitchToSignUpEvent());
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
