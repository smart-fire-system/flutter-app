import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/app_version.dart';

class InfoCollection {
  int maxBranchCode;
  int maxCompanyCode;
  int maxContractCode;
  int maxUserCode;
  int maxEmergencyVisitCode;
  int maxSignatureCode;
  int maxVisitReportCode;
  int maxNotificationCode;
  AppVersionData appVersionData;
  InfoCollection({
    required this.maxBranchCode,
    required this.maxCompanyCode,
    required this.maxContractCode,
    required this.maxUserCode,
    required this.maxEmergencyVisitCode,
    required this.maxSignatureCode,
    required this.maxVisitReportCode,
    required this.maxNotificationCode,
    required this.appVersionData,
  });

  factory InfoCollection.fromSnapshot(QuerySnapshot snapshot) {
    Map<String, dynamic> maxCodeMap = {};
    Map<String, dynamic> appVersionMap = {};
    for (var doc in snapshot.docs) {
      if (doc.id == 'maxCode') {
        maxCodeMap = doc.data() as Map<String, dynamic>;
      } else if (doc.id == 'appVersion') {
        appVersionMap = doc.data() as Map<String, dynamic>;
      }
    }
    return InfoCollection(
      maxBranchCode: maxCodeMap['branch']?.toInt() ?? 0,
      maxCompanyCode: maxCodeMap['company']?.toInt() ?? 0,
      maxContractCode: maxCodeMap['contract']?.toInt() ?? 0,
      maxUserCode: maxCodeMap['user']?.toInt() ?? 0,
      maxEmergencyVisitCode: maxCodeMap['emergencyVisit'] as int,
      maxSignatureCode: maxCodeMap['signature']?.toInt() ?? 0,
      maxVisitReportCode: maxCodeMap['visitReport']?.toInt() ?? 0,
      maxNotificationCode: maxCodeMap['notification']?.toInt() ?? 0,
      appVersionData: AppVersionData.fromMap(appVersionMap),
    );
  }
}
