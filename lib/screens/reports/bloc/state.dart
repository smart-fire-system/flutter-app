import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsNewContractInfoLoaded extends ReportsState {
  final List<ReportItem> items;
  final List<ContractComponentCategory> categories;
  final List<ContractComponentItem> components;
  final Employee? employee;
  final List<Client> clients;
  ReportsNewContractInfoLoaded({
    required this.items,
    required this.categories,
    required this.components,
    required this.employee,
    required this.clients,
  });
}

class ReportsContractComponentsLoaded extends ReportsState {
  final List<ContractComponentItem> items;
  final List<ContractComponentCategory> categories;
  ReportsContractComponentsLoaded(
      {required this.items, required this.categories});
}

class ReportsContractsLoaded extends ReportsState {
  final List<ContractData> contracts;
  final List<ReportItem> items;
  final dynamic user;
  ReportsContractsLoaded({required this.contracts, required this.items, required this.user});
}

class ReportsLoading extends ReportsState {
  ReportsLoading();
}

class ReportsSaved extends ReportsState {
  ReportsSaved();
}

class ReportsSigned extends ReportsState {
  final ContractData contract;
  ReportsSigned({required this.contract});
}