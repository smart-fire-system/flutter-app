import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/app_version.dart';

class ErrorScreen extends StatelessWidget {
  final void Function() onRefreshClick;
  final String errorMessage;
  final IconData icon;
  const ErrorScreen({
    super.key,
    required this.onRefreshClick,
    required this.errorMessage,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).error),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [CustomStyle.redLight, CustomStyle.redDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CustomStyle.redDark.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).error,
                  style: CustomStyle.largeText25B,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CustomStyle.greySuperLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CustomStyle.greyLight),
                  ),
                  child: SelectableText(
                    errorMessage,
                    style: CustomStyle.smallText,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onRefreshClick,
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          'Retry',
                          style: CustomStyle.normalButtonTextWhite,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomStyle.redDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  appVersion,
                  style: CustomStyle.smallTextGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
