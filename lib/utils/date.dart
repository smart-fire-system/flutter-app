import 'package:cloud_firestore/cloud_firestore.dart';

class DateHelper {
  static String formatDate(DateTime? date) {
    if (date == null) return ' - ';
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Accepts Firebase Timestamp
  static String timeAgoFromTimestamp(Timestamp timestamp) {
    return timeAgoFromDateTime(timestamp.toDate());
  }

  /// Accepts DateTime
  static String timeAgoFromDateTime(DateTime dateTime) {
    final now = DateTime.now();

    // If timestamp is in the future
    if (dateTime.isAfter(now)) {
      return 'just now';
    }

    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${_plural(difference.inMinutes)} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${_plural(difference.inHours)} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${_plural(difference.inDays)} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${_plural(weeks)} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${_plural(months)} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${_plural(years)} ago';
    }
  }
  static String _plural(int value) => value == 1 ? '' : 's';
}
