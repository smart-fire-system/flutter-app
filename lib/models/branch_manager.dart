import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';

class BranchManager extends User {
  int index;
  Branch branch;

  BranchManager({
    required this.index,
    required this.branch,
    required super.id,
    required super.name,
    required super.email,
    required super.countryCode,
    required super.phoneNumber,
  }) : super(role: UserRole.branchManager);
}
