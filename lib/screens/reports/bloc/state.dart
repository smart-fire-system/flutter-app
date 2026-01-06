import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/emergency_visit.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';

enum ReportsMessage {
  contractComponentsSaved,
  contractSaved,
  contractSigned,
  visitReportSaved,
  visitReportSigned,
  emergencyVisitRequested,
  sharedWithUpdated,
  firstPartyInformationUpdated,
}

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsAuthenticated extends ReportsState {
  final List<ContractItem>? contractItems;
  final List<VisitReportData>? visitReports;
  final List<EmergencyVisitData>? emergencyVisits;
  final List<ContractCategory>? contractCategories;
  final List<ContractComponent>? contractComponents;
  final List<ContractData>? contracts;
  final dynamic user;
  final List<Employee>? employees;
  final List<Client>? clients;
  ReportsMessage? message;
  String? error;
  ReportsAuthenticated({
    required this.contractItems,
    required this.visitReports,
    required this.emergencyVisits,
    required this.contractCategories,
    required this.contractComponents,
    required this.contracts,
    required this.user,
    required this.employees,
    required this.clients,
    this.message,
    this.error,
  });
}

class ReportsNotAuthenticated extends ReportsState {
  final ReportsMessage? message;
  final String? error;
  ReportsNotAuthenticated({this.message, this.error});
}

class ReportsLoading extends ReportsState {
  ReportsLoading();
}
