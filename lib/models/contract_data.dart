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

  Map<String, dynamic> toJson() {
    return {
      'metaData': metaData.toJson(),
      'paramContractNumber': paramContractNumber,
      'paramContractAgreementDay': paramContractAgreementDay,
      'paramContractAgreementHijriDate': paramContractAgreementHijriDate,
      'paramContractAgreementGregorianDate':
          paramContractAgreementGregorianDate,
      'paramFirstPartyName': paramFirstPartyName,
      'paramFirstPartyCommNumber': paramFirstPartyCommNumber,
      'paramFirstPartyAddress': paramFirstPartyAddress,
      'paramFirstPartyRep': paramFirstPartyRep,
      'paramFirstPartyRepIdNumber': paramFirstPartyRepIdNumber,
      'paramFirstPartyG': paramFirstPartyG,
      'paramSecondPartyName': paramSecondPartyName,
      'paramSecondPartyCommNumber': paramSecondPartyCommNumber,
      'paramSecondPartyAddress': paramSecondPartyAddress,
      'paramSecondPartyRep': paramSecondPartyRep,
      'paramSecondPartyRepIdNumber': paramSecondPartyRepIdNumber,
      'paramSecondPartyG': paramSecondPartyG,
      'paramContractAddDate': paramContractAddDate,
      'paramContractPeriod': paramContractPeriod,
      'paramContractAmount': paramContractAmount,
      'componentsData': componentsData.toJson(),
    };
  }

  factory ContractData.fromJson(Map<String, dynamic> json) {
    final data = ContractData();
    data.metaData = ContractMetaData.fromJson(
        (json['metaData'] as Map?)?.cast<String, dynamic>() ?? {});
    data.paramContractNumber = json['paramContractNumber']?.toString();
    data.paramContractAgreementDay =
        json['paramContractAgreementDay']?.toString();
    data.paramContractAgreementHijriDate =
        json['paramContractAgreementHijriDate']?.toString();
    data.paramContractAgreementGregorianDate =
        json['paramContractAgreementGregorianDate']?.toString();
    data.paramFirstPartyName = json['paramFirstPartyName']?.toString();
    data.paramFirstPartyCommNumber =
        json['paramFirstPartyCommNumber']?.toString();
    data.paramFirstPartyAddress = json['paramFirstPartyAddress']?.toString();
    data.paramFirstPartyRep = json['paramFirstPartyRep']?.toString();
    data.paramFirstPartyRepIdNumber =
        json['paramFirstPartyRepIdNumber']?.toString();
    data.paramFirstPartyG = json['paramFirstPartyG']?.toString();
    data.paramSecondPartyName = json['paramSecondPartyName']?.toString();
    data.paramSecondPartyCommNumber =
        json['paramSecondPartyCommNumber']?.toString();
    data.paramSecondPartyAddress = json['paramSecondPartyAddress']?.toString();
    data.paramSecondPartyRep = json['paramSecondPartyRep']?.toString();
    data.paramSecondPartyRepIdNumber =
        json['paramSecondPartyRepIdNumber']?.toString();
    data.paramSecondPartyG = json['paramSecondPartyG']?.toString();
    data.paramContractAddDate = json['paramContractAddDate']?.toString();
    data.paramContractPeriod = json['paramContractPeriod']?.toString();
    data.paramContractAmount = json['paramContractAmount']?.toString();
    data.componentsData = ContractComponents.fromJson(
        (json['componentsData'] as Map?)?.cast<String, dynamic>() ?? {});
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