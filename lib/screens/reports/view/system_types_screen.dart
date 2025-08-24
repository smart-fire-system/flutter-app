import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class SystemTypesScreen extends StatelessWidget {
  const SystemTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'System Types'),
      body: Center(
        child: Text(''),
      ),
    );
  }
}
