import 'package:bloc/bloc.dart';

import '../../../socket/socket_service.dart';
import '../../model/chats_model.dart';
import '../../service/api_service.dart';
import '../events/chat_events.dart';
import '../states/chat_states.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    SocketService.socket?.on('get-message', (data) {
      if (isClosed) return;
      Message msg = Message(
        id: data['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        sender: data['senderId'],
        receiver: data['receiverId'],
        content: data['content'],
        timestamp: DateTime.now(),
        messageType: '',
      );
      add(ReceiveMessageEvent(msg));
    });

    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        var messages = await ChatApiService.fetchMessages(
            event.loggedInUserId, event.otherUserId);
      

        emit(ChatLoaded(messages: messages));
      } catch (e) {
        emit(ChatError(message: e.toString()));
      }
    });

    on<SendMessageEvent>((event, emit) {
      try {
        SocketService.sendMessage(
            event.senderId, event.receiverId, event.content);

        // if (state is ChatLoaded) {
        //   final currentMessages = (state as ChatLoaded).messages;
        //   final newMessage = Message(
        //     id: DateTime.now().millisecondsSinceEpoch.toString(),
        //     sender: event.senderId,
        //     receiver: event.receiverId,
        //     content: event.content,
        //     timestamp: DateTime.now(),
        //     messageType: '',
        //   );
        //   emit(ChatLoaded(messages: [...currentMessages, newMessage]));
        // }
      } catch (e) {
        emit(ChatError(message: e.toString()));
      }
    });

    on<ReceiveMessageEvent>((event, emit) {
      if (state is ChatLoaded) {
        final currentMessages =
            List<Message>.from((state as ChatLoaded).messages);
        currentMessages.add(event.message);
        emit(ChatLoaded(messages: currentMessages));
        // final currentMessages = (state as ChatLoaded).messages;
        // emit(ChatLoaded(messages: [...currentMessages, event.message]));
      } else {
        emit(ChatLoaded(messages: [event.message]));
      }
    });
  }
}
