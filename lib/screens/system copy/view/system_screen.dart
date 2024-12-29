import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class SystemScreen extends StatefulWidget {
  final String title;
  const SystemScreen({super.key, required this.title});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).system),
      body: const Center(
        child: Text('System Screen'),
      ),
    );
  }
}
