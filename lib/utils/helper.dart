import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../login/view/login_screen.dart';
import '../socket/socket_service.dart';

class Helper{
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> logout(BuildContext context) async {
    try {
     
      await _storage.deleteAll();

     
      SocketService.disconnectSocket();

     
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }
}