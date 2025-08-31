import 'dart:convert';

import 'package:chatting_app/utils/api_url.dart';
import 'package:http/http.dart' as http;
import '../../users/model/users_model.dart';

class SignupApiService {
  Future<Users> registerUser(String name, String email, String password) async {
    final url = Uri.parse('${ApiUrl.baseUrl}/api/user/register');
    print('signup url : $url');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return Users.fromJson(result['user']);
    } else {
      throw Exception(
          jsonDecode(response.body)['message'] ?? "Registration failed");
    }
  }
}
