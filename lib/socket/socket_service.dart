import 'package:chatting_app/utils/api_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketService {
  static IO.Socket? socket;

  static void initializeSocket() {
    socket = IO.io(ApiUrl.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket?.on('connect', (_) => print('Connected: ${socket?.id}'));

    socket?.on('login', (data) => print('Login event: $data'));

    // Listen for messages
    socket?.on('get-message', (data) {
      print('New message received: $data');
      // Add to Bloc to update UI
      // context.read<ChatBloc>().add(ReceiveMessageEvent(data));
      // Note: pass context when initializing if needed
    });
  }

  static void joinRoom(String userId) {
    socket?.emit('join-room', {'userId': userId});
  }

  static void sendMessage(String senderId, String receiverId, String content) {
    socket?.emit('send-message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void disconnectSocket() {
    if (socket != null && socket!.connected) {
      socket?.disconnect();
      socket = null;
      print('Socket disconnected');
    }
  }
}
