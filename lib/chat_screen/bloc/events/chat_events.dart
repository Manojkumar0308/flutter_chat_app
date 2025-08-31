import '../../model/chats_model.dart';

abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String loggedInUserId;
  final String otherUserId;

  LoadMessages(this.loggedInUserId, this.otherUserId);
}

class SendMessageEvent extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String content;

  SendMessageEvent(this.senderId, this.receiverId, this.content);
}

class ReceiveMessageEvent extends ChatEvent {
  final Message message;

  ReceiveMessageEvent(this.message);
}