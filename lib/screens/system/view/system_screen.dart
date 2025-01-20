import 'package:fire_alarm_system/repositories/test_repository.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).system),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            TestRespository().addCanFlags();
          },
          child: const Text('Go to System Reports Details'),
        ),
      ),
    );
  }
}
