class Message {
  final String id;
  final String? sender;
  final String? receiver;
  final String? content;
  final String? messageType;
  final DateTime timestamp;

  
  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.messageType,
    required this.timestamp,
  });

  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
    id: json['_id']?.toString() ?? '',          // fallback empty string
    sender: json['sender']?.toString() ?? '',   
    receiver: json['receiver']?.toString() ?? '',
    content: json['content']?.toString() ?? '',
    messageType: json['messageType']?.toString() ?? 'text', // default
    timestamp: json['timestamp'] != null
        ? DateTime.parse(json['timestamp'])
        : DateTime.now(),                      // fallback
  );
  }



}
