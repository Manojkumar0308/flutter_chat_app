import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login/view/login_screen.dart';
import 'users/view/users_list.dart';
import 'utils/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  final userId = await SecureStorage.getUserId();
  runApp(MyApp(initialUserId: userId));
}

class MyApp extends StatelessWidget {
  final String? initialUserId;
  const MyApp({super.key, this.initialUserId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal.withOpacity(0.8),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal.withOpacity(0.8),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: initialUserId != null
          ? UserScreen(
              loggedInUserId: initialUserId.toString(),
            )
          : const LoginScreen(),
    );
  }
}
