import 'dart:io';

import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/home/bloc/state.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [];

  IconData _getIcon(String clickAction) {
    switch (clickAction) {
      case 'OPEN_PLAY_STORE':
        return Icons.update_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Future<void> _openStorePage() async {
    Uri url;
    if (Platform.isAndroid) {
      url = Uri.parse("market://details?id=com.hassan.firealarm");
    } else if (Platform.isIOS) {
      url = Uri.parse("https://apps.apple.com/app/id1234567890");
    } else {
      return;
    }
    Uri fallback = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.hassan.firealarm",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }

  String _formatNotificationTime(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (!diff.isNegative && diff.inMinutes < 60) {
      final mins = diff.inMinutes.clamp(0, 59);
      return '$mins mins ago';
    }
    if (!diff.isNegative && diff.inHours < 24) {
      final hours = diff.inHours;
      return '$hours hours ago';
    }
    final local = createdAt.toLocal();
    return DateFormat('dd-MM-yyyy\nhh:mm a').format(local);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeAuthenticated) {
          notifications = state.notifications;
          return Scaffold(
            appBar: CustomAppBar(title: S.of(context).notifications),
            body: notifications.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined,
                              size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'No notifications',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You’re all caught up. New alerts will appear here.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final createdAt = item.createdAt?.toDate();
                      final timeLabel = createdAt != null
                          ? _formatNotificationTime(createdAt)
                          : null;
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.redAccent.withOpacity(0.12),
                            child: Icon(_getIcon(item.clickAction ?? ''),
                                color: Colors.redAccent),
                          ),
                          title: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            item.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: timeLabel == null
                              ? null
                              : Text(
                                  timeLabel,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                          onTap: item.clickAction == 'OPEN_PLAY_STORE'
                              ? _openStorePage
                              : null,
                        ),
                      );
                    },
                  ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
