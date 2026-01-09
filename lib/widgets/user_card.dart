import 'package:fire_alarm_system/l10n/app_localizations.dart';
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
  final String? searchQuery;

  const CustomUserCard({
    super.key,
    required this.index,
    required this.code,
    required this.name,
    required this.role,
    this.companyName,
    this.branchName,
    this.onTap,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = (searchQuery ?? '').toLowerCase();
    return ListTile(
      leading: Text(
        index.toString(),
        style: CustomStyle.mediumTextBRed,
      ),
      title: _highlightText(name, query, CustomStyle.mediumTextBRed),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${l10n.code}: ',
                style: CustomStyle.smallTextB,
              ),
              Expanded(
                child: _highlightText(
                    code.toString(), query, CustomStyle.smallText),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${l10n.role}: ',
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
                  '${l10n.company}: ',
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
                  '${l10n.branch}: ',
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

  Widget _highlightText(String text, String query, TextStyle style) {
    if (query.isEmpty) return Text(text, style: style);
    final lower = text.toLowerCase();
    final start = lower.indexOf(query);
    if (start == -1) return Text(text, style: style);
    final end = start + query.length;
    return RichText(
      text: TextSpan(
        children: [
          if (start > 0) TextSpan(text: text.substring(0, start), style: style),
          TextSpan(
            text: text.substring(start, end),
            style: style.copyWith(
                backgroundColor: Colors.yellow, color: Colors.black),
          ),
          if (end < text.length)
            TextSpan(text: text.substring(end), style: style),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
