import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/message.dart';
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
  bool? _isNotificationsEnabled;
  StreamSubscription<Locale>? _languageSub;
  bool _isArabic = false;
  bool _isLoadingNotifications = true;
  bool _isLoadingNext = false;
  bool _isLoadingEnableOrDisable = false;
  bool _hasMore = true;
  AppMessage? _message;

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

  Widget _buildNotificationToggle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Future<void> onToggle(bool value) async {
      if (value) {
        // Turning notifications ON
        context.read<NotificationsBloc>().add(EnableNotifications());
      } else {
        // Turning notifications OFF - show confirmation
        final result = await CustomAlert.showConfirmation(
            context: context,
            title: l10n.notifications_unsubscribe_confirmation_title,
            buttons: [
              CustomAlertConfirmationButton(
                  title: l10n.yes,
                  value: 1,
                  backgroundColor: Colors.deepOrange,
                  textColor: Colors.white),
              CustomAlertConfirmationButton(
                  title: l10n.cancel,
                  value: 0,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white),
            ]);
        if (result == 1 && context.mounted) {
          context.read<NotificationsBloc>().add(DisableNotifications());
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isNotificationsEnabled == true
              ? [
                  const Color(0xFFE8F5E9),
                  const Color(0xFFC8E6C9),
                ]
              : [
                  const Color(0xFFFFF3E0),
                  const Color(0xFFFFE0B2),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                (_isNotificationsEnabled == true ? Colors.green : Colors.orange)
                    .withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon indicator
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _isNotificationsEnabled == true
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isNotificationsEnabled == true
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_off_rounded,
                  color: _isNotificationsEnabled == true
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isNotificationsEnabled == true
                          ? l10n.notifications_enabled
                          : l10n.notifications_disabled,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _isNotificationsEnabled == true
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isNotificationsEnabled == true
                          ? l10n.notifications_enabled_subtitle
                          : l10n.notifications_disabled_subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _isNotificationsEnabled == true
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                    ),
                  ],
                ),
              ),
              // Toggle switch
              Transform.scale(
                scale: 1.1,
                child: Switch(
                  value: _isNotificationsEnabled == true,
                  onChanged: onToggle,
                  activeThumbColor: Colors.white,
                  activeTrackColor: Colors.green.shade600,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.orange.shade400,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
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

  void _buildFakeNotifications() {
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsAuthenticated) {
          _message = state.message;
          _notifications = state.notifications;
          _isNotificationsEnabled = state.isNotificationsEnabled;
          _hasMore = state.hasMore;
          _isLoadingNext = state.isLoadingNext;
          _isLoadingNotifications = state.isLoadingNotifications;
          _isLoadingEnableOrDisable = state.isLoadingEnableOrDisable;
          state.isLoadingNotifications = false;
          state.isLoadingNext = false;
          state.isLoadingEnableOrDisable = false;
          state.message = null;
          if (_isLoadingNotifications == true) {
            _buildFakeNotifications();
          }
        } else if (state is! NotificationsAuthenticated) {
          _buildFakeNotifications();
        }
        if (_message != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(_message!.getText(context)),
              backgroundColor: _message!.getColor(),
            ));
            _message = null;
          });
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
                if (_isNotificationsEnabled != null)
                  _buildNotificationToggle(context),
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, NotificationsState state) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoadingNotifications || _isLoadingEnableOrDisable) {
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
    return _notifications.isEmpty && !_isLoadingNotifications
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
            enabled: _isLoadingNotifications,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                final nearBottom = notification.metrics.extentAfter < 200;
                final canLoad = state is NotificationsAuthenticated &&
                    _hasMore &&
                    !_isLoadingNext;
                if (nearBottom && canLoad) {
                  _isLoadingNext = true;
                  context
                      .read<NotificationsBloc>()
                      .add(LoadNextNotifications());
                }
                return false;
              },
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                itemCount: _notifications.length +
                    ((_hasMore || _isLoadingNext) ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final isFooter = index >= _notifications.length;
                  if (isFooter) {
                    final isLoadingNext = _isLoadingNext;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: isLoadingNext
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Load more',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              )
                            : TextButton(
                                onPressed: () {
                                  if (!_hasMore) return;
                                  context
                                      .read<NotificationsBloc>()
                                      .add(LoadNextNotifications());
                                },
                                child: const Text('Load more'),
                              ),
                      ),
                    );
                  }

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
                        backgroundColor:
                            Colors.redAccent.withValues(alpha: 0.12),
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
            ),
          );
  }
}
