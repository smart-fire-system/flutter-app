import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DateLocalizations {
  DateLocalizations();
  static String of(dynamic date, {String format = 'dd/MM/yyyy hh:mm a'}) {
    if (date is Timestamp) {
      date = date.toDate().toLocal();
    } else if (date is DateTime) {
      date = date.toLocal();
    } else {
      return ' - ';
    }
    return DateFormat(format, LocalizationUtil.languageCode).format(date);
  }
}

class DateHelper {
  static String formatDate(DateTime? date) {
    if (date == null) return ' - ';
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

enum TimeAgoFormat { long, short }

class TimeAgoHelper {
  static String of(
    BuildContext context,
    dynamic value, {
    TimeAgoFormat format = TimeAgoFormat.long,
    DateTime? now,
    bool arabicIndicDigits = true, // optional switch
  }) {
    final dt = _toDateTime(value);
    if (dt == null) return '';

    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode.toLowerCase() == 'ar';

    final current = now ?? DateTime.now();

    if (dt.isAfter(current)) {
      return _maybeArabicDigits(
        isArabic,
        arabicIndicDigits,
        format == TimeAgoFormat.short
            ? l10n.time_now_short
            : l10n.time_now_long,
      );
    }

    final diff = current.difference(dt);

    String result;

    if (diff.inMinutes < 1) {
      result = format == TimeAgoFormat.short
          ? l10n.time_now_short
          : l10n.time_now_long;
    } else if (diff.inMinutes < 60) {
      final n = diff.inMinutes;
      result = format == TimeAgoFormat.short
          ? l10n.time_min_short(n)
          : l10n.time_min_long(n);
    } else if (diff.inHours < 24) {
      final n = diff.inHours;
      result = format == TimeAgoFormat.short
          ? l10n.time_hour_short(n)
          : l10n.time_hour_long(n);
    } else if (diff.inDays < 7) {
      final n = diff.inDays;
      result = format == TimeAgoFormat.short
          ? l10n.time_day_short(n)
          : l10n.time_day_long(n);
    } else if (diff.inDays < 30) {
      final n = (diff.inDays / 7).floor().clamp(1, 999999);
      result = format == TimeAgoFormat.short
          ? l10n.time_week_short(n)
          : l10n.time_week_long(n);
    } else if (diff.inDays < 365) {
      final n = (diff.inDays / 30).floor().clamp(1, 999999);
      result = format == TimeAgoFormat.short
          ? l10n.time_month_short(n)
          : l10n.time_month_long(n);
    } else {
      final n = (diff.inDays / 365).floor().clamp(1, 999999);
      result = format == TimeAgoFormat.short
          ? l10n.time_year_short(n)
          : l10n.time_year_long(n);
    }

    // Convert digits at the end so gen-l10n placeholder types stay int everywhere.
    return _maybeArabicDigits(isArabic, arabicIndicDigits, result);
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    return null;
  }

  static String _maybeArabicDigits(bool isArabic, bool enabled, String text) {
    if (!isArabic || !enabled) return text;
    return _toArabicIndicDigitsInText(text);
  }

  static String _toArabicIndicDigitsInText(String input) {
    const map = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };

    final buf = StringBuffer();
    for (final ch in input.split('')) {
      buf.write(map[ch] ?? ch);
    }
    return buf.toString();
  }
}
