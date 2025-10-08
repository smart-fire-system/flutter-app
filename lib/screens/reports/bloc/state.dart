import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';

enum ReportsMessage {
  contractComponentsSaved,
  contractSaved,
  contractSigned,
}

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsAuthenticated extends ReportsState {
  final List<ContractItem>? contractItems;
  final List<ContractCategory>? contractCategories;
  final List<ContractComponent>? contractComponents;
  final List<ContractData>? contracts;
  final dynamic user;
  final List<Employee>? employees;
  final List<Client>? clients;
  final ReportsMessage? message;
  final String? error;
  ReportsAuthenticated({
    required this.contractItems,
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
