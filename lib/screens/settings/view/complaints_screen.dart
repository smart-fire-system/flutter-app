import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class ComplaintsScreen extends StatefulWidget {
  final String title;
  const ComplaintsScreen({super.key, required this.title});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).complaints),
      body: const Center(
        child: Text('Complaints Screen'),
      ),
    );
  }
}
