
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/container_bloc.dart';
import '../bloc/container_event.dart';
import '../signup/bloc/signup_bloc/signup_bloc.dart';
import '../signup/bloc/signup_event/signup_event.dart';
import '../signup/bloc/signup_states/signup_states.dart';

class SignUpContainer extends StatelessWidget {
  const SignUpContainer({super.key});

  @override
  Widget build(BuildContext context) {
     final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
    final size = MediaQuery.of(context).size;
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error, style: const TextStyle(color: Colors.red))),
      );
    } else if (state is SignUpSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.green))),
      );
      context.read<ContainerBloc>().add(SwitchToLoginEvent());
    }
      },
      builder: (context, state) {
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
                      color: Colors.teal.withOpacity(0.15),
                      shape: BoxShape.circle),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  cursorWidth: 1.2,
                  cursorColor: Colors.black,
                  cursorHeight: 16,
                  decoration: InputDecoration(
                    hintText: "Username",
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
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
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
                  controller: passwordController,
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
                  ),
                ),
                const SizedBox(height: 30),

               state is SignUpLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                        onPressed: () {
                          context.read<SignUpBloc>().add(
                                SignUpSubmitted(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
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
                        context.read<ContainerBloc>().add(SwitchToLoginEvent());
                      },
                      child: Text(
                        "Login",
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
      },
    );
  }
}
