import 'package:chatting_app/bloc/container_bloc.dart';
import 'package:chatting_app/login/bloc/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/container_state.dart';
import '../../signup/bloc/signup_bloc/signup_bloc.dart';
import '../../signup/services/api_service.dart';
import '../../utils/colors.dart';
import '../../widgets/login_container.dart';
import '../../widgets/signup_container.dart';
import '../repository/repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ContainerBloc()),
        BlocProvider(
          create: (context) => LoginBloc(repository: LoginRepository()),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocProvider(
          create: (BuildContext context) => ContainerBloc(),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
            child: Stack(
              alignment: Alignment.center,
              children: [
                BlocBuilder<ContainerBloc, ContainerState>(
                  builder: (context, state) {
                    if (state is LoginState) {
                      return LoginContainer();
                    } else if (state is SignUpState) {
                      return BlocProvider(
                        create: (context) => SignUpBloc(authRepository: SignupApiService()),
                        child: const SignUpContainer(),
                      );
                    }
                    return LoginContainer(); // Default
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
