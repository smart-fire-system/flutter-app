
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItem {
  String id;
  String title;
  String body;
  List<String> topics;
  String? clickAction;
  Timestamp? createdAt;
  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.topics,
    this.clickAction,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'topics': topics,
      'click_action': clickAction,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      topics: List<String>.from(map['topics']),
      clickAction: map['click_action'],
      createdAt: map['createdAt'],
    );
  }
}
