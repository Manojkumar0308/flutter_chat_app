import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../socket/socket_service.dart';
import '../../utils/api_url.dart';

class ApiService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('${ApiUrl.baseUrl}/api/user/login');
    print(url);
    final map = json.encode({'email': email, 'password': password});
    print(map);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: map,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final body = json.decode(response.body);
    if (response.statusCode == 200 && body['status'] == 'success') {
      print('Login successful: $body');
      SocketService.initializeSocket();
      return body;
    } else {
      throw Exception(body['message'] ?? 'Login failed');
    }
  }
}
