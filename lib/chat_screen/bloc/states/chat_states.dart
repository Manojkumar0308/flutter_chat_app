import '../../model/chats_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  ChatLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String message;
  ChatError({required this.message});
}