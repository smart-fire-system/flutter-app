import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';

abstract class ReportsEvent {}

class Refresh extends ReportsEvent {
  final ReportsMessage? message;
  final String? error;
  Refresh({this.message, this.error});
}

class SaveContractComponentsRequested extends ReportsEvent {
  final List<ContractComponent> component;
  SaveContractComponentsRequested({required this.component});
}

class SaveContractRequested extends ReportsEvent {
  final ContractData contract;
  SaveContractRequested({required this.contract});
}

class SaveVisitReportRequested extends ReportsEvent {
  final VisitReportData visitReport;
  SaveVisitReportRequested({required this.visitReport});
}

class SignContractRequested extends ReportsEvent {
  final ContractData contract;
  SignContractRequested({required this.contract});
}

class SignVisitReportRequested extends ReportsEvent {
  final VisitReportData visitReport;
  SignVisitReportRequested({required this.visitReport});
}

class FirstPartyInformationUpateRequested extends ReportsEvent {
  final ContractFirstParty firstParty;
  FirstPartyInformationUpateRequested({required this.firstParty});
}

class SharedWithUpdateRequested extends ReportsEvent {
  final String contractId;
  final List<String> sharedWith;
  SharedWithUpdateRequested(
      {required this.contractId, required this.sharedWith});
}

class RequestEmergencyVisitRequested extends ReportsEvent {
  final String contractId;
  final String description;
  RequestEmergencyVisitRequested(
      {required this.contractId, required this.description});
}
