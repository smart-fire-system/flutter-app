import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/signature.dart';

class VisitReportData {
  VisitReportData();
  String? id;
  int? code;
  ContractMetaData contractMetaData = ContractMetaData();
  String? employeeId;
  String? contractId;
  String? paramClientName;
  String? paramClientAddress;
  String? paramContractNumber;
  String? paramVisitDate;
  String? paramSystemStatus;
  String? paramSystemStatusBool;
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
      'systemStatusBool': paramSystemStatusBool,
      'notes': paramNotes,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'code': code,
      'contractId': contractId,
      'parameters': parametersToJson(),
      'componentsData': componentsData.toJson(),
      'companyId': contractMetaData.employee?.branch.company.id,
      'branchId': contractMetaData.employee?.branch.id,
      'createdAt': createdAt,
      'sharedWith': sharedWith,
      'employeeSignatureId': employeeSignature.id,
      'clientSignatureId': clientSignature.id,
    };
  }

  factory VisitReportData.fromJson(Map<String, dynamic> json) {
    final data = VisitReportData();
    data.employeeId = json['employeeId']?.toString();
    data.code = (json['code'] is int)
        ? json['code'] as int
        : int.tryParse(json['code']?.toString() ?? '');
    data.contractId = json['contractId']?.toString();
    data.paramClientName = json['parameters']['clientName']?.toString();
    data.paramClientAddress = json['parameters']['clientAddress']?.toString();
    data.paramContractNumber = json['parameters']['contractNumber']?.toString();
    data.paramVisitDate = json['parameters']['visitDate']?.toString();
    data.paramSystemStatus = json['parameters']['systemStatus']?.toString();
    data.paramSystemStatusBool = json['parameters']['systemStatusBool']?.toString();
    data.paramNotes = json['parameters']['notes']?.toString();
    data.componentsData = ContractComponents.fromJson(
        (json['componentsData'] as Map?)?.cast<String, dynamic>() ?? {});
    data.createdAt = json['createdAt'];
    data.sharedWith = json['sharedWith'] ?? [];
    data.employeeSignature.id = json['employeeSignatureId']?.toString();
    data.clientSignature.id = json['clientSignatureId']?.toString();
    return data;
  }
}
