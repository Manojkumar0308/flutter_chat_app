import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../users/model/users_model.dart';
import '../../socket/socket_service.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../bloc/events/chat_events.dart';
import '../bloc/states/chat_states.dart';
import '../model/chats_model.dart';

class ChatScreen extends StatefulWidget {
  final Users user;
  final String loggedInUserId;
  const ChatScreen(
      {super.key, required this.user, required this.loggedInUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SocketService.initializeSocket();
    SocketService.joinRoom(widget.loggedInUserId);

    context
        .read<ChatBloc>()
        .add(LoadMessages(widget.loggedInUserId, widget.user.id));

   
  }


  void _handleIncomingMessage(dynamic data) {
    if (!mounted) return; 
    final messageMap = Map<String, dynamic>.from(data);
    final message = Message.fromJson(messageMap);
    context.read<ChatBloc>().add(ReceiveMessageEvent(message));
    _scrollToBottom();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    context.read<ChatBloc>().add(SendMessageEvent(
        widget.loggedInUserId, widget.user.id, _controller.text.trim()));
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp);
  }

  @override
  void dispose() {
    SocketService.socket?.off('get-message', _handleIncomingMessage);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.user.name}')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    final messages = state.messages;
                    if (messages.isEmpty) {
                      return const Center(child: Text('No messages'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        bool isMe = msg.sender == widget.loggedInUserId;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.teal[600]
                                      : Colors.grey[300],
                                  borderRadius: isMe
                                      ? const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        )
                                      : const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      msg.content.toString(),
                                      style: TextStyle(
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          _formatTime(msg.timestamp),
                                          style: TextStyle(
                                              color: isMe
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 10),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                       
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  
                  return const SizedBox.shrink();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      hintText: 'Type a message...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                    onPressed: _sendMessage, icon: const Icon(Icons.send))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
