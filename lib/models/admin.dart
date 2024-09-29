import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';

class Admin extends User {
  int index;

  Admin({
    required this.index,
    required super.id,
    required super.name,
    required super.email,
    required super.countryCode,
    required super.phoneNumber,
  }) : super(role: UserRole.admin);
}
