import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.complaints),
      body: const Center(
        child: Text('Complaints Screen'),
      ),
    );
  }
}
