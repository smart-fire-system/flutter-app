import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class CustomUserCard extends StatelessWidget {
  final int index;
  final int code;
  final String name;
  final String role;
  final String? companyName;
  final String? branchName;
  final void Function()? onTap;

  const CustomUserCard({
    super.key,
    required this.index,
    required this.code,
    required this.name,
    required this.role,
    this.companyName,
    this.branchName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        index.toString(),
        style: CustomStyle.mediumTextBRed,
      ),
      title: Text(
        name,
        style: CustomStyle.mediumTextBRed,
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${S.of(context).code}: ',
                style: CustomStyle.smallTextB,
              ),
              Expanded(
                child: Text(
                  code.toString(),
                  style: CustomStyle.smallText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${S.of(context).role}: ',
                style: CustomStyle.smallTextB,
              ),
              Expanded(
                child: Text(
                  role,
                  style: CustomStyle.smallText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          if (companyName != null)
            Row(
              children: [
                Text(
                  '${S.of(context).company}: ',
                  style: CustomStyle.smallTextB,
                ),
                Expanded(
                  child: Text(
                    companyName!,
                    style: CustomStyle.smallText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          if (branchName != null)
            Row(
              children: [
                Text(
                  '${S.of(context).branch}: ',
                  style: CustomStyle.smallTextB,
                ),
                Expanded(
                  child: Text(
                    branchName!,
                    style: CustomStyle.smallText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
