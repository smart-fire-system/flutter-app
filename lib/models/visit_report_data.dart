import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';

class VisitReportData {
  VisitReportData();
  String? id;
  int? index;
  ContractMetaData contractMetaData = ContractMetaData();
  String? paramClientName;
  String? paramClientAddress;
  String? paramContractNumber;
  String? paramVisitDate;
  String? paramSystemStatus;
  String? paramNotes;
  Timestamp? createdAt;
  List<String> sharedWith = [];
  ContractComponents componentsData = ContractComponents();

  Map<String, dynamic> parametersToJson() {
    return {
      'clientName': paramClientName,
      'clientAddress': paramClientAddress,
      'contractNumber': paramContractNumber,
      'visitDate': paramVisitDate,
      'systemStatus': paramSystemStatus,
      'notes': paramNotes,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'parameters': parametersToJson(),
      'componentsData': componentsData.toJson(),
      'companyId': contractMetaData.employee?.branch.company.id,
      'branchId': contractMetaData.employee?.branch.id,
      'createdAt': createdAt,
      'sharedWith': sharedWith,
    };
  }

  factory VisitReportData.fromJson(Map<String, dynamic> json) {
    final data = VisitReportData();
    data.id = json['id']?.toString();
    data.contractMetaData = ContractMetaData.fromJson(
        (json['contractMetaData'] as Map?)?.cast<String, dynamic>() ?? {});
    data.index = (json['index'] is int)
        ? json['index'] as int
        : int.tryParse(json['index']?.toString() ?? '') ?? 0;
    data.paramClientName = json['parameters']['clientName']?.toString();
    data.paramClientAddress = json['parameters']['clientAddress']?.toString();
    data.paramContractNumber = json['parameters']['contractNumber']?.toString();
    data.paramVisitDate = json['parameters']['visitDate']?.toString();
    data.paramSystemStatus = json['parameters']['systemStatus']?.toString();
    data.paramNotes = json['parameters']['notes']?.toString();
    data.componentsData = ContractComponents.fromJson(
        (json['componentsData'] as Map?)?.cast<String, dynamic>() ?? {});
    data.createdAt = json['createdAt'];
    data.sharedWith = json['sharedWith'] ?? [];
    return data;
  }
}
