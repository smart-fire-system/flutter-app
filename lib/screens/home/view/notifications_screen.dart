import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/home/bloc/state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [];

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
                ? const Center(child: Text('No notifications'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final createdAt = item.createdAt?.toDate();
                      return ListTile(
                        leading: const Icon(Icons.notifications_rounded,
                            color: Colors.redAccent),
                        title: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (createdAt != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  createdAt.toLocal().toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          // Future: handle clickAction if available
                        },
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
