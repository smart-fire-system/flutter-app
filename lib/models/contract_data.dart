import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';

class ContractData {
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
  
}

class ContractMetaData {
  String? id;
  int? code;
  Employee? employee;
  Client? client;
  DateTime? startDate;
  DateTime? endDate;
  ContractState? state;
  String? employeeSignatureId;
  String? clientSignatureId;
}

enum ContractState {
  draft,
  pendingClient,
  active,
  requestCancellation,
  expired,
  cancelled,
}
