import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';

class UserAuth {
  AuthStatus authStatus;
  User? user;

  UserAuth({required this.authStatus});
}
