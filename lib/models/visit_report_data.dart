import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';

class VisitReportData {
  VisitReportData();
  String? id;
  ContractMetaData contractMetaData = ContractMetaData();
  String? contractId;
  String? paramClientName;
  String? paramClientAddress;
  String? paramContractNumber;
  String? paramVisitDate;
  String? paramSystemStatus;
  String? paramNotes;
  Timestamp? createdAt;
  List<dynamic> sharedWith = [];
  SignatureData employeeSignature = SignatureData();
  SignatureData clientSignature = SignatureData();

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
      'contractId': contractId,
      'parameters': parametersToJson(),
      'componentsData': componentsData.toJson(),
      'companyId': contractMetaData.employee?.branch.company.id,
      'branchId': contractMetaData.employee?.branch.id,
      'createdAt': createdAt,
      'sharedWith': sharedWith,
      'employeeSignature': employeeSignature.toJson(),
      'clientSignature': clientSignature.toJson(),
    };
  }

  factory VisitReportData.fromJson(Map<String, dynamic> json) {
    final data = VisitReportData();
    data.contractId = json['contractId']?.toString();
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
    data.employeeSignature = SignatureData.fromJson(
        (json['employeeSignature'] as Map?)?.cast<String, dynamic>() ?? {});
    data.clientSignature = SignatureData.fromJson(
        (json['clientSignature'] as Map?)?.cast<String, dynamic>() ?? {});
    return data;
  }
}
