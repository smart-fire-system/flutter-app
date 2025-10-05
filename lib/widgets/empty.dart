import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomEmpty extends StatelessWidget {
  final String message;
  const CustomEmpty({
    super.key,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(message, style: CustomStyle.mediumTextBRed),
        ],
      ),
    );
  }
}
