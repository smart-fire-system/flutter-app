import 'package:fire_alarm_system/models/app_version.dart';
import 'package:flutter/material.dart';

Widget buildUpdateNeeded(BuildContext context, AppVersionData appVersionData) {
  return const Scaffold(
    body: Center(
      child: Text('Update Needed'),
    ),
  );
}