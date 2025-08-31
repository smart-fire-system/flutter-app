import 'package:fire_alarm_system/models/report.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<ReportItem> items;
  ReportsLoaded({required this.items});
}

class ReportsContractComponentsLoaded extends ReportsState {
  final List<ContractComponentItem> items;
  final List<ContractComponentCategory> categories;
  ReportsContractComponentsLoaded({required this.items, required this.categories});
}

class ReportsLoading extends ReportsState {
  ReportsLoading();
}

class ReportsSaved extends ReportsState {
  ReportsSaved();
}
