import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 3)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String content;

  @HiveField(3)
  bool isUser; // true if message is from user, false if from AI

  @HiveField(4)
  DateTime timestamp;

  @HiveField(5)
  Map<String, dynamic>? metadata; // For storing additional info like recommended doctors, etc.

  ChatMessage({
    required this.id,
    required this.userId,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }
}
