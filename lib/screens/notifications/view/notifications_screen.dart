import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/notifications/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/notifications/bloc/state.dart';
import 'package:fire_alarm_system/screens/notifications/bloc/event.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fire_alarm_system/utils/open_store.dart';
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];
  bool? _isNotificationGranted;
  StreamSubscription<Locale>? _languageSub;
  bool _isArabic = false;
  bool _isSubscribed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isArabic = LocalizationUtil.myLocale.languageCode == 'ar';
    _languageSub = LocalizationUtil.languageChangedStream.listen((locale) {
      if (!mounted) return;
      setState(() {
        _isArabic = locale.languageCode == 'ar';
      });
    });
  }

  Widget _buildPermissionBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isNotificationGranted == true) return const SizedBox.shrink();
    return Material(
      color: const Color(0xFFFFF2F2),
      child: InkWell(
        onTap: () {
          context
              .read<NotificationsBloc>()
              .add(RequestNotificationPermission());
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
                  _isNotificationGranted == false
                      ? l10n.notifications_permission_disabled_system
                      : l10n.notifications_permission_disabled_tap_enable,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<NotificationsBloc>()
                      .add(RequestNotificationPermission());
                },
                child: Text(
                  _isNotificationGranted == false
                      ? l10n.notifications_open_settings
                      : l10n.notifications_enable,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isSubscribed == true) return const SizedBox.shrink();
    return Material(
      color: const Color(0xFFFFF2F2),
      child: InkWell(
        onTap: () {
          context
              .read<NotificationsBloc>()
              .add(RequestNotificationPermission());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.sync, color: Colors.redAccent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.notifications_not_synced_banner,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<NotificationsBloc>()
                      .add(SubscribeToUserTopics());
                },
                child: Text(
                  l10n.notifications_sync,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNotificationDetails(NotificationItem item) async {
    final l10n = AppLocalizations.of(context)!;
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
                  _isArabic ? item.arTitle : item.enTitle,
                  style: CustomStyle.largeTextB,
                ),
                if (item.createdAt != null) ...[
                  Text(
                    DateLocalizations.of(item.createdAt),
                    style: CustomStyle.smallTextGrey,
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  _isArabic ? item.arBody : item.enBody,
                  style: CustomStyle.mediumText,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (item.data['clickAction'] == 'OPEN_PLAY_STORE') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            openStore();
                          },
                          icon: const Icon(Icons.update_rounded),
                          label: Text(l10n.notifications_update_application),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.close),
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

  @override
  void dispose() {
    _languageSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is! NotificationsAuthenticated) {
          _notifications = List.filled(
            7,
            NotificationItem(
              id: 'fake',
              enTitle: 'Fake Notification',
              enBody: 'This is a fake notification',
              arTitle: 'Fake Notification',
              arBody: 'This is a fake notification',
              topics: ['fake'],
              createdAt: Timestamp.fromDate(DateTime.now()),
            ),
          );
          _isLoading = true;
        } else {
          _notifications = state.notifications;
          _isNotificationGranted = state.isNotificationGranted;
          _isSubscribed = state.isSubscribed;
          _isLoading = false;
        }
        return Scaffold(
          appBar: CustomAppBar(title: l10n.notifications),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationsBloc>().add(Refresh());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_isLoading) _buildPermissionBanner(context),
                if (!_isLoading) _buildSubscriptionBanner(context),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      AppLoading().show(
        context: context,
        screen: AppScreen.viewNotifications,
        title: l10n.wait_while_loading,
        type: 'loading',
      );
    } else {
      AppLoading().dismiss(
        context: context,
        screen: AppScreen.viewNotifications,
      );
    }
    return _notifications.isEmpty && !_isLoading
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
                    l10n.notifications_empty_title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.notifications_empty_subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          )
        : Skeletonizer(
            enabled: _isLoading,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _notifications[index];
                final timeLabel = item.createdAt != null
                    ? TimeAgoHelper.of(context, item.createdAt,
                        format: TimeAgoFormat.long)
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
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.12),
                      child: Icon(_getIcon(item.data['clickAction'] ?? ''),
                          color: Colors.redAccent),
                    ),
                    title: Text(
                      _isArabic ? item.arTitle : item.enTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      _isArabic ? item.arBody : item.enBody,
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
            ),
          );
  }
}
