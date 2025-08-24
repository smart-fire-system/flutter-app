import 'package:fire_alarm_system/models/report.dart';
abstract class ReportsEvent {}

class ReportsItemsRequested extends ReportsEvent {
  ReportsItemsRequested();
}

class ReportsContractComponentsRequested extends ReportsEvent {
  ReportsContractComponentsRequested();
}

class ReportsContractComponentsAddRequested extends ReportsEvent {
  final ContractComponentItem item;
  ReportsContractComponentsAddRequested({required this.item});
}