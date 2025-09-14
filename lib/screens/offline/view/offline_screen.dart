import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Offline Screen"),
      body: Center(
        child: Text('Offline Screen'),
      ),
    );
  }
}
