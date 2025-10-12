import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/user.dart';

class SignatureData {
  SignatureData();
  int? code;
  String? id;
  String? name;
  Timestamp? createdAt;
  String? userId;
  String? contractId;
  String? visitReportId;
  UserInfo? user;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'createdAt': createdAt,
      'userId': userId ?? user?.id,
      'contractId': contractId,
      'visitReportId': visitReportId,
    };
  }

  factory SignatureData.fromJson(Map<String, dynamic> json) {
    final s = SignatureData();
    s.code = (json['code'] is int)
        ? json['code'] as int
        : int.tryParse(json['code']?.toString() ?? '');
    s.name = json['name']?.toString();
    s.userId = json['userId']?.toString();
    s.createdAt = json['createdAt'];
    s.contractId = json['contractId']?.toString();
    s.visitReportId = json['visitReportId']?.toString();
    return s;
  }
}
