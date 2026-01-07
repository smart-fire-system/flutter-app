import 'package:cloud_firestore/cloud_firestore.dart';

class CommentData {
  String userId;
  String comment;
  Timestamp createdAt;
  EmergencyVisitStatus oldStatus;
  EmergencyVisitStatus newStatus;
  CommentData({
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.oldStatus,
    required this.newStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'comment': comment,
      'createdAt': createdAt,
      'oldStatus': oldStatus.name,
      'newStatus': newStatus.name,
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
          ? EmergencyVisitStatus.values.firstWhere(
              (e) => e.name == map['oldStatus'],
              orElse: () => EmergencyVisitStatus.pending,
            )
          : EmergencyVisitStatus.pending,
      newStatus: map['newStatus']?.toString() != ""
          ? EmergencyVisitStatus.values.firstWhere(
              (e) => e.name == map['newStatus'],
              orElse: () => EmergencyVisitStatus.pending,
            )
          : EmergencyVisitStatus.pending,
    );
  }
}

enum EmergencyVisitStatus {
  pending,
  approved,
  rejected,
  completed,
  cancelled,
}

class EmergencyVisitData {
  String id;
  int code;
  String description;
  String companyId;
  String branchId;
  String contractId;
  String requestedBy;
  List<CommentData> comments;
  EmergencyVisitStatus status;
  Timestamp createdAt;
  EmergencyVisitData({
    required this.id,
    required this.description,
    this.code = 0,
    required this.companyId,
    required this.branchId,
    required this.contractId,
    required this.requestedBy,
    required this.comments,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'companyId': companyId,
      'branchId': branchId,
      'contractId': contractId,
      'requestedBy': requestedBy,
      'comments': comments.map((c) => c.toMap()).toList(),
      'status': status.name,
      'createdAt': createdAt,
    };
  }

  factory EmergencyVisitData.fromMap(Map<String, dynamic> map) {
    final rawComments = map['comments'];
    final List<CommentData> parsedComments = (rawComments is List)
        ? rawComments
            .whereType<Map>()
            .map((c) => CommentData.fromMap(c.cast<String, dynamic>()))
            .toList()
        : <CommentData>[];

    return EmergencyVisitData(
      id: map['id']?.toString() ?? '',
      code: map['code'] ?? 0,
      description: map['description']?.toString() ?? '',
      companyId: map['companyId']?.toString() ?? '',
      branchId: map['branchId']?.toString() ?? '',
      contractId: map['contractId']?.toString() ?? '',
      requestedBy: map['requestedBy']?.toString() ?? '',
      comments: parsedComments,
      status: EmergencyVisitStatus.values.firstWhere(
        (e) => e.name == map['status']?.toString(),
        orElse: () => EmergencyVisitStatus.pending,
      ),
      createdAt: (map['createdAt'] is Timestamp)
          ? map['createdAt'] as Timestamp
          : Timestamp.now(),
    );
  }
}
