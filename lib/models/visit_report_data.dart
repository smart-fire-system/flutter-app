import 'package:fire_alarm_system/models/report.dart';

class VisitReportData {
  VisitReportData();
  String? id;
  String? contractId;
  int? index;
  String? paramClientName;
  String? paramClientAddress;
  String? paramContractNumber;
  String? paramVisitDate;
  String? paramSystemStatus;
  ContractComponents componentsData = ContractComponents();
  // categoryIndex -> typeName -> {'quantity': String, 'notes': String}
  Map<String, Map<String, Map<String, String>>> componentDetails = {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractId': contractId,
      'index': index,
      'paramClientName': paramClientName,
      'paramClientAddress': paramClientAddress,
      'paramContractNumber': paramContractNumber,
      'paramVisitDate': paramVisitDate,
      'paramSystemStatus': paramSystemStatus,
      'componentsData': componentsData.toJson(),
    };
  }

  factory VisitReportData.fromJson(Map<String, dynamic> json) {
    final data = VisitReportData();
    data.id = json['id']?.toString();
    data.contractId = json['contractId']?.toString();
    data.index = (json['index'] is int)
        ? json['index'] as int
        : int.tryParse(json['index']?.toString() ?? '') ?? 0;
    data.paramClientName = json['paramClientName']?.toString();
    data.paramClientAddress = json['paramClientAddress']?.toString();
    data.paramContractNumber = json['paramContractNumber']?.toString();
    data.paramVisitDate = json['paramVisitDate']?.toString();
    data.paramSystemStatus = json['paramSystemStatus']?.toString();
    data.componentsData = ContractComponents.fromJson(
        (json['componentsData'] as Map?)?.cast<String, dynamic>() ?? {});
    final cd = json['componentDetails'];
    if (cd is Map) {
      data.componentDetails = cd.map((k, v) => MapEntry(
          k.toString(),
          (v as Map).map((k2, v2) => MapEntry(
              k2.toString(),
              (v2 as Map)
                  .map((k3, v3) => MapEntry(k3.toString(), v3.toString()))))));
    }
    return data;
  }
}
