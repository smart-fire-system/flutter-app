import 'package:fire_alarm_system/models/contract_data.dart';
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

class ReportsContractComponentsSaveRequested extends ReportsEvent {
  final List<ContractComponentItem> items;
  ReportsContractComponentsSaveRequested({required this.items});
}

class SaveContractRequested extends ReportsEvent {
  final ContractData contract;
  SaveContractRequested({required this.contract});
}

class AllContractsRequested extends ReportsEvent {
  AllContractsRequested();
}

class SignContractRequested extends ReportsEvent {
  final ContractData contract;
  SignContractRequested({required this.contract});
}
