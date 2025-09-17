import 'package:fire_alarm_system/models/report.dart';

class ContractData {
  DateTime? contractStartDate;
  DateTime? contractEndDate;
  String? contractId;
  String? contractCode;
  String? employeeId;
  String? clientId;
  String? branchId;
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