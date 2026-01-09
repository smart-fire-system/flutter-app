import 'package:cloud_firestore/cloud_firestore.dart';

enum ComplaintStatus {
  open,
  inProgress,
  cancelled,
  resolved,
  moreInfoRequired,
  closed,
}

class CommentData {
  String userId;
  String comment;
  Timestamp createdAt;
  ComplaintStatus oldStatus;
  ComplaintStatus newStatus;
  List<String> attachments;
  CommentData({
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.oldStatus,
    required this.newStatus,
    this.attachments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'comment': comment,
      'createdAt': createdAt,
      'oldStatus': oldStatus.name,
      'newStatus': newStatus.name,
      'attachments': attachments,
    };
  }

  factory CommentData.fromMap(Map<String, dynamic> map) {
    return CommentData(
      userId: map['userId']?.toString() ?? '',
      comment: map['comment']?.toString() ?? '',
      createdAt: (map['createdAt'] is Timestamp)
          ? map['createdAt'] as Timestamp
          : Timestamp.now(),
      oldStatus: map['oldStatus']?.toString() != ""
          ? ComplaintStatus.values.firstWhere(
              (e) => e.name == map['oldStatus'],
              orElse: () => ComplaintStatus.open,
            )
          : ComplaintStatus.open,
      newStatus: map['newStatus']?.toString() != ""
          ? ComplaintStatus.values.firstWhere(
              (e) => e.name == map['newStatus'],
              orElse: () => ComplaintStatus.open,
            )
          : ComplaintStatus.open,
      attachments: List<String>.from(map['attachments'] ?? []),
    );
  }
}

class ComplaintData {
  String id;
  String contractId;
  String companyId;
  String branchId;
  String requestedBy;
  ComplaintStatus status;
  Timestamp createdAt;
  List<CommentData> comments;
  ComplaintData({
    required this.id,
    required this.contractId,
    required this.companyId,
    required this.branchId,
    required this.requestedBy,
    required this.status,
    required this.createdAt,
    required this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contractId': contractId,
      'companyId': companyId,
      'branchId': branchId,
      'requestedBy': requestedBy,
      'status': status.name,
      'createdAt': createdAt,
      'comments': comments.map((e) => e.toMap()).toList(),
    };
  }

  factory ComplaintData.fromMap(Map<String, dynamic> map) {
    return ComplaintData(
      id: map['id'],
      contractId: map['contractId'],
      companyId: map['companyId'],
      branchId: map['branchId'],
      requestedBy: map['requestedBy'],
      status: map['status']?.toString() != ""
          ? ComplaintStatus.values.firstWhere(
              (e) => e.name == map['status'],
              orElse: () => ComplaintStatus.open,
            )
          : ComplaintStatus.open,
      createdAt: map['createdAt'],
      comments: List<CommentData>.from(map['comments'] ?? []),
    );
  }
}
