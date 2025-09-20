import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';

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
  List<ContractComponentsData> components = [];
  // categoryIndex -> typeName -> {'quantity': String, 'notes': String}
  Map<String, Map<String, Map<String, String>>> componentDetails = {};

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
      'components': components
          .map((c) => {
                'category': {
                  'arName': c.category.arName,
                  'enName': c.category.enName,
                },
                'items': c.items
                    .map((i) => {
                          'arName': i.arName,
                          'enName': i.enName,
                          'description': i.description,
                          'categoryIndex': i.categoryIndex,
                        })
                    .toList(),
              })
          .toList(),
      'componentDetails': componentDetails,
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

    final comps = json['components'];
    if (comps is List) {
      data.components = comps.map((e) {
        final map = (e as Map).cast<String, dynamic>();
        final catMap = (map['category'] as Map?)?.cast<String, dynamic>() ?? {};
        final category = ContractComponentCategory(
          arName: catMap['arName']?.toString() ?? '',
          enName: catMap['enName']?.toString() ?? '',
        );
        final itemsList = (map['items'] as List?) ?? [];
        final items = itemsList.map((it) {
          final itMap = (it as Map).cast<String, dynamic>();
          return ContractComponentItem(
            arName: itMap['arName']?.toString() ?? '',
            enName: itMap['enName']?.toString() ?? '',
            description: itMap['description']?.toString() ?? '',
            categoryIndex: (itMap['categoryIndex'] is int)
                ? itMap['categoryIndex'] as int
                : int.tryParse(itMap['categoryIndex']?.toString() ?? '') ?? 0,
          );
        }).toList();
        return ContractComponentsData(category: category, items: items);
      }).toList();
    }
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

class ContractMetaData {
  ContractMetaData();
  String? id;
  int? code;
  Employee? employee;
  Client? client;
  DateTime? startDate;
  DateTime? endDate;
  ContractState? state;
  String? employeeSignatureId;
  String? clientSignatureId;

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
      'employeeSignatureId': employeeSignatureId,
      'clientSignatureId': clientSignatureId,
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
    m.employeeSignatureId = json['employeeSignatureId']?.toString();
    m.clientSignatureId = json['clientSignatureId']?.toString();
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
