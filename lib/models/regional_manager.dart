import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';

class RegionalManager extends User {
  int index;
  List<Branch> branches;

  RegionalManager({
    required this.index,
    required this.branches,
    required super.id,
    required super.name,
    required super.email,
    required super.countryCode,
    required super.phoneNumber,
  }) : super(role: UserRole.regionalManager);
}
