import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItem {
  String id;
  String enTitle;
  String enBody;
  String arTitle;
  String arBody;
  List<String> topics;
  Map<String, dynamic> data;
  Timestamp? createdAt;
  NotificationItem({
    required this.id,
    required this.enTitle,
    required this.enBody,
    required this.arTitle,
    required this.arBody,
    required this.topics,
    this.data = const {},
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enTitle': enTitle,
      'enBody': enBody,
      'arTitle': arTitle,
      'arBody': arBody,
      'topics': topics,
      'data': data,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'],
      enTitle: map['enTitle']?.toString() ?? map['title']?.toString() ?? '',
      enBody: map['enBody']?.toString() ?? map['body']?.toString() ?? '',
      arTitle: map['arTitle']?.toString() ?? map['title']?.toString() ?? '',
      arBody: map['arBody']?.toString() ?? map['body']?.toString() ?? '',
      topics: List<String>.from(map['topics']),
      data: map['data'] ?? {},
      createdAt: map['createdAt'],
    );
  }
}
