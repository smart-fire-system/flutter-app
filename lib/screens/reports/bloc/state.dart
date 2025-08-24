import 'package:fire_alarm_system/models/report.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<ReportItem> items;
  ReportsLoaded({required this.items});
}

class ReportsContractComponentsLoaded extends ReportsState {
  final List<ContractComponentItem> items;
  ReportsContractComponentsLoaded({required this.items});
}


class ReportsLoading extends ReportsState {
  ReportsLoading();
}
