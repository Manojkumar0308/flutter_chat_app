import 'dart:convert';

import '../../utils/api_url.dart';
import '../model/chats_model.dart';
import 'package:http/http.dart' as http;

class ChatApiService {
  static Future<List<Message>> fetchMessages(
      String userId, String otherUserId) async {
    final uri = Uri.parse(
        '${ApiUrl.baseUrl}/api/message/getmsg?userId=$userId&otherUserId=$otherUserId');
    final response = await http.get(uri);
    print('chatList url $uri');
    print('chatList ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => Message.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
