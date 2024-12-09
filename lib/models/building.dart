
import 'package:fire_alarm_system/models/branch.dart';

class Building {
  String id;
  Branch branch;
  String name;
  String description;

  Building({required this.id, required this.branch, required this.name, required this.description});
}