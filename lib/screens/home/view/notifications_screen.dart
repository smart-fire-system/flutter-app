import 'dart:io';
import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/home/bloc/state.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fire_alarm_system/utils/app_version.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [];
  bool isNotificationGranted = false;
  PermissionStatus? _notificationStatus;

  @override
  void initState() {
    super.initState();
    _initPermissionState();
  }

  Future<void> _initPermissionState() async {
    final status = await Permission.notification.status;
    if (!mounted) return;
    setState(() {
      isNotificationGranted = status.isGranted;
      _notificationStatus = status;
    });
  }

  Future<void> _requestPermission() async {
    final previousStatus = _notificationStatus;
    final status = await Permission.notification.request();
    if (status.isGranted || status.isLimited) {
    } else {
      if ((previousStatus?.isDenied == true && status.isDenied) ||
          status.isPermanentlyDenied) {
        await _openSystemSettings();
      }
    }
    if (!mounted) return;
    setState(() {
      isNotificationGranted = status.isGranted || status.isLimited;
      _notificationStatus = status;
    });
  }

  Future<void> _openSystemSettings() async {
    final opened = await openAppSettings();
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'To enable notifications, open Settings > Apps > Fire Alarm > Notifications',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildPermissionBanner(BuildContext context) {
    if (isNotificationGranted) return const SizedBox.shrink();
    final isPermanentlyDenied =
        _notificationStatus?.isPermanentlyDenied == true;
    return Material(
      color: const Color(0xFFFFF2F2),
      child: InkWell(
        onTap: () {
          if (isPermanentlyDenied) {
            _openSystemSettings();
          } else {
            _requestPermission();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_off_rounded,
                  color: Colors.redAccent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isPermanentlyDenied
                      ? 'Notifications are disabled in system settings.'
                      : 'Notifications are disabled. Tap to enable.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (isPermanentlyDenied) {
                    _openSystemSettings();
                  } else {
                    _requestPermission();
                  }
                },
                child: Text(
                  isPermanentlyDenied ? 'Open Settings' : 'Enable',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNotificationDetails(NotificationItem item) async {
    final createdAt = item.createdAt?.toDate();
    final fullTime = createdAt == null
        ? null
        : DateFormat('dd-MM-yyyy hh:mm a').format(createdAt.toLocal());
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: CustomStyle.largeTextB,
                ),
                if (fullTime != null) ...[
                  Text(
                    fullTime,
                    style: CustomStyle.smallTextGrey,
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  item.body,
                  style: CustomStyle.mediumText,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (item.clickAction == 'OPEN_PLAY_STORE') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _openStorePage();
                          },
                          icon: const Icon(Icons.update_rounded),
                          label: const Text('Update application'),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
      if (mins == 1) {
        return '1 min ago';
      } else {
        return '$mins mins ago';
      }
    }
    if (!diff.isNegative && diff.inHours < 24) {
      final hours = diff.inHours;
      if (hours == 1)
      {
        return '1 hour ago';
      } else {
        return '$hours hours ago';
      }
    }
    final local = createdAt.toLocal();
    return DateFormat('dd-MM-yyyy\nhh:mm a').format(local);
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
          final Widget content = notifications.isEmpty
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                          backgroundColor:
                              Colors.redAccent.withValues(alpha: 0.12),
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
                        onTap: () => _showNotificationDetails(item),
                      ),
                    );
                  },
                );
          return Scaffold(
            appBar: CustomAppBar(title: S.of(context).notifications),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPermissionBanner(context),
                Expanded(child: content),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  Platform.isAndroid ? androidAppVersion : iosAppVersion,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
