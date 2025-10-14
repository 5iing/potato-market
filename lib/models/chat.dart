import 'user.dart';

class Chat {
  final int? id;
  final int? chatRoomId;
  final int? senderId;
  final String? content;
  final String? messageType;
  final String? createdAt;
  final User sender;

  Chat({
    this.id,
    this.chatRoomId,
    this.senderId,
    this.content,
    this.messageType,
    this.createdAt,
    required this.sender,
  });
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(sender: json['sender']);
  }
}
