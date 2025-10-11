import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignatureData {
  SignatureData();
  int? code;
  String? id;
  String? name;
  Timestamp? createdAt;
  String? userId;
  String? contractId;
  UserInfo? user;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'createdAt': createdAt,
      'userId': userId ?? user?.id,
      'contractId': contractId,
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
    return s;
  }
}

class ContractData {
  ContractData();
  ContractMetaData metaData = ContractMetaData();
  String? paramContractNumber;
  String? paramContractAgreementDay;
  String? paramContractAgreementHijriDate;
  String? paramContractAgreementGregorianDate;
  String? paramFirstPartyName;
  String? paramFirstPartyCommNumber;
  String? paramFirstPartyAddress;
  String? paramFirstPartyRep;
  String? paramFirstPartyRepIdNumber;
  String? paramFirstPartyG;
  String? paramSecondPartyName;
  String? paramSecondPartyCommNumber;
  String? paramSecondPartyAddress;
  String? paramSecondPartyRep;
  String? paramSecondPartyRepIdNumber;
  String? paramSecondPartyG;
  String? paramContractAddDate;
  String? paramContractPeriod;
  String? paramContractAmount;
  ContractComponents componentsData = ContractComponents();
  Timestamp? createdAt;
  List<dynamic> sharedWith = [];
  List<Client> sharedWithClients = [];
  List<Employee> sharedWithEmployees = [];

  Map<String, dynamic> parametersToJson() {
    return {
      'contractNumber': paramContractNumber,
      'contractAgreementDay': paramContractAgreementDay,
      'contractAgreementHijriDate': paramContractAgreementHijriDate,
      'contractAgreementGregorianDate': paramContractAgreementGregorianDate,
      'firstPartyName': paramFirstPartyName,
      'firstPartyCommNumber': paramFirstPartyCommNumber,
      'firstPartyAddress': paramFirstPartyAddress,
      'firstPartyRep': paramFirstPartyRep,
      'firstPartyRepIdNumber': paramFirstPartyRepIdNumber,
      'firstPartyG': paramFirstPartyG,
      'secondPartyName': paramSecondPartyName,
      'secondPartyCommNumber': paramSecondPartyCommNumber,
      'secondPartyAddress': paramSecondPartyAddress,
      'secondPartyRep': paramSecondPartyRep,
      'secondPartyRepIdNumber': paramSecondPartyRepIdNumber,
      'secondPartyG': paramSecondPartyG,
      'contractAddDate': paramContractAddDate,
      'contractPeriod': paramContractPeriod,
      'contractAmount': paramContractAmount,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'metaData': metaData.toJson(),
      'parameters': parametersToJson(),
      'componentsData': componentsData.toJson(),
      'createdAt': createdAt,
      'companyId': metaData.employee?.branch.company.id,
      'branchId': metaData.employee?.branch.id,
      'sharedWith': sharedWith,
    };
  }

  factory ContractData.fromJson(Map<String, dynamic> json) {
    final data = ContractData();
    data.metaData = ContractMetaData.fromJson(
        (json['metaData'] as Map?)?.cast<String, dynamic>() ?? {});
    data.paramContractNumber = json['parameters']['contractNumber']?.toString();
    data.paramContractAgreementDay =
        json['parameters']['contractAgreementDay']?.toString();
    data.paramContractAgreementHijriDate =
        json['parameters']['contractAgreementHijriDate']?.toString();
    data.paramContractAgreementGregorianDate =
        json['parameters']['contractAgreementGregorianDate']?.toString();
    data.paramFirstPartyName = json['parameters']['firstPartyName']?.toString();
    data.paramFirstPartyCommNumber =
        json['parameters']['firstPartyCommNumber']?.toString();
    data.paramFirstPartyAddress = json['parameters']['firstPartyAddress']?.toString();
    data.paramFirstPartyRep = json['parameters']['firstPartyRep']?.toString();
    data.paramFirstPartyRepIdNumber =
        json['parameters']['firstPartyRepIdNumber']?.toString();
    data.paramFirstPartyG = json['parameters']['firstPartyG']?.toString();
    data.paramSecondPartyName =
        json['parameters']['secondPartyName']?.toString();
    data.paramSecondPartyCommNumber =
        json['parameters']['secondPartyCommNumber']?.toString();
    data.paramSecondPartyAddress =
        json['parameters']['secondPartyAddress']?.toString();
    data.paramSecondPartyRep = json['parameters']['secondPartyRep']?.toString();
    data.paramSecondPartyRepIdNumber =
        json['parameters']['secondPartyRepIdNumber']?.toString();
    data.paramSecondPartyG = json['parameters']['secondPartyG']?.toString();
    data.paramContractAddDate =
        json['parameters']['contractAddDate']?.toString();
    data.paramContractPeriod = json['parameters']['contractPeriod']?.toString();
    data.paramContractAmount = json['parameters']['contractAmount']?.toString();
    data.componentsData = ContractComponents.fromJson(
        (json['componentsData'] as Map?)?.cast<String, dynamic>() ?? {});
    data.createdAt = json['createdAt'];
    data.sharedWith = json['sharedWith'];
    return data;
  }
}

class ContractMetaData {
  ContractMetaData();
  SignatureData employeeSignature = SignatureData();
  SignatureData clientSignature = SignatureData();
  String? id;
  int? code;
  Employee? employee;
  Client? client;
  DateTime? startDate;
  DateTime? endDate;
  ContractState? state;

  String? employeeId;
  String? clientId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'employeeId': employeeId ?? employee?.info.id,
      'clientId': clientId ?? client?.info.id,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'state': state?.name,
      'employeeSignatureId': employeeSignature.id,
      'clientSignatureId': clientSignature.id,
    };
  }

  factory ContractMetaData.fromJson(Map<String, dynamic> json) {
    final m = ContractMetaData();
    m.id = json['id']?.toString();
    m.code = (json['code'] is int)
        ? json['code'] as int
        : int.tryParse(json['code']?.toString() ?? '');
    m.employeeId = json['employeeId']?.toString();
    m.clientId = json['clientId']?.toString();
    final s = json['startDate']?.toString();
    final e = json['endDate']?.toString();
    m.startDate = s != null ? DateTime.tryParse(s) : null;
    m.endDate = e != null ? DateTime.tryParse(e) : null;
    final stateStr = json['state']?.toString();
    if (stateStr != null) {
      try {
        m.state = ContractState.values
            .firstWhere((v) => v.name.toLowerCase() == stateStr.toLowerCase());
      } catch (_) {
        m.state = null;
      }
    }
    m.employeeSignature.id = json['employeeSignatureId']?.toString();
    m.clientSignature.id = json['clientSignatureId']?.toString();
    return m;
  }
}

enum ContractState {
  draft,
  pendingClient,
  active,
  requestCancellation,
  expired,
  cancelled,
}
