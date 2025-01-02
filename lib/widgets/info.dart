import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class CustomInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const CustomInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: CustomStyle.redDark),
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style: CustomStyle.mediumTextBRed,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            ...children,
          ],
        ),
      ),
    );
  }
}

class CustomInfoItem extends StatelessWidget {
  final String? title;
  final String value;

  const CustomInfoItem({
    super.key,
    this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          if (title != null)
            Text(
              "$title: ",
              style: CustomStyle.smallTextB,
            ),
          Expanded(
            child: Text(
              value,
              style: CustomStyle.smallText,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
