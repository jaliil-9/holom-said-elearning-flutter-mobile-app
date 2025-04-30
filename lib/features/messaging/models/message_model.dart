enum MessageType { individual, broadcast }

enum MessageStatus { sent, read }

class Message {
  final String? id;
  final String senderId;
  final String? receiverId; // Null for broadcast messages
  final String content;
  final String subject;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final String senderName;
  final String? senderProfileUrl;
  final bool isAdminSender;

  Message({
    this.id,
    required this.senderId,
    this.receiverId,
    required this.content,
    required this.subject,
    required this.type,
    this.status = MessageStatus.sent,
    DateTime? createdAt,
    required this.senderName,
    this.senderProfileUrl,
    required this.isAdminSender,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      subject: json['subject'],
      type: MessageType.values.byName(json['type']),
      status: MessageStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['created_at']),
      senderName: json['sender_name'],
      senderProfileUrl: json['sender_profile_url'],
      isAdminSender: json['is_admin_sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      'content': content,
      'subject': subject,
      'type': type.name,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'sender_name': senderName,
      if (senderProfileUrl != null) 'sender_profile_url': senderProfileUrl,
      'is_admin_sender': isAdminSender,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    String? subject,
    MessageType? type,
    MessageStatus? status,
    DateTime? createdAt,
    String? senderName,
    String? senderProfileUrl,
    bool? isAdminSender,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      subject: subject ?? this.subject,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      senderName: senderName ?? this.senderName,
      senderProfileUrl: senderProfileUrl ?? this.senderProfileUrl,
      isAdminSender: isAdminSender ?? this.isAdminSender,
    );
  }
}
