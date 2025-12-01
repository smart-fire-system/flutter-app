import 'dart:io';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItem {
  String id;
  String title;
  String body;
  List<String> topics;
  String? clickAction;
  Timestamp? createdAt;
  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.topics,
    this.clickAction,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'topics': topics,
      'clickAction': clickAction,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      topics: List<String>.from(map['topics']),
      clickAction: map['clickAction'],
      createdAt: map['createdAt'],
    );
  }
}

class NotificationsRepository {
  final FirebaseMessaging _messaging;
  final AppRepository appRepository;
  List<NotificationItem> notifications = [];
  List<String> subscribedTopics = [];
  QuerySnapshot? notificationsSnapshot;
  NotificationsRepository({required this.appRepository})
      : _messaging = FirebaseMessaging.instance;

  void refreshNotifications() {
    if (notificationsSnapshot == null) {
      notifications = [];
      return;
    }
    notifications = [];
    for (var doc in notificationsSnapshot!.docs) {
      final notification =
          NotificationItem.fromMap(doc.data() as Map<String, dynamic>);
      if (subscribedTopics
          .any((element) => notification.topics.contains(element))) {
        notifications.add(notification);
      }
    }
    notifications.sort((a, b) {
      final aDate = a.createdAt?.toDate();
      final bDate = b.createdAt?.toDate();
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
  }

  Future<bool> isNotificationPermissionGranted() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<bool> requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return false;
    }
    return true;
  }

  Future<bool> setupUserToken() async {
    final token = await _messaging.getToken();
    if (appRepository.authRepository.firebaseUser == null || token == null) {
      return false;
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(appRepository.authRepository.firebaseUser!.uid)
        .collection('tokens')
        .doc(token); // docId == token (easy to delete later)
    await userDoc.set({
      'token': token,
      'platform': Platform.operatingSystem,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    _messaging.onTokenRefresh.listen((newToken) async {
      final newDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(appRepository.authRepository.firebaseUser!.uid)
          .collection('tokens')
          .doc(newToken);

      await newDoc.set({
        'token': newToken,
        'platform': Platform.operatingSystem,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
    return true;
  }

  Future<bool> subscribeToUserTopics() async {
    final user = appRepository.authRepository.userRole;
    if (user == null || !await isNotificationPermissionGranted()) {
      return false;
    }
    try {
      subscribedTopics.add('user_${user.info.id}');
      subscribedTopics.add('all_users');
      if (Platform.isAndroid) {
        subscribedTopics.add('android_users');
      } else if (Platform.isIOS) {
        subscribedTopics.add('ios_users');
      }
      if (user is MasterAdmin) {
        subscribedTopics.add('masterAdmins');
      } else if (user is Admin) {
        subscribedTopics.add('admins');
      } else if (user is CompanyManager) {
        subscribedTopics.add('companyManagers');
        subscribedTopics.add('companyManagers_${user.company.id}');
        subscribedTopics.add('company_${user.company.id}');
      } else if (user is BranchManager) {
        subscribedTopics.add('branchManagers');
        subscribedTopics.add('branchManagers_${user.branch.id}');
        subscribedTopics.add('branch_${user.branch.id}');
        subscribedTopics.add('company_${user.branch.company.id}');
      } else if (user is Employee) {
        subscribedTopics.add('employees');
        subscribedTopics.add('employees_${user.branch.id}');
        subscribedTopics.add('branch_${user.branch.id}');
        subscribedTopics.add('company_${user.branch.company.id}');
      } else if (user is Client) {
        subscribedTopics.add('clients');
        subscribedTopics.add('clients_${user.branch.id}');
        subscribedTopics.add('branch_${user.branch.id}');
        subscribedTopics.add('company_${user.branch.company.id}');
      }
      if (await isNotificationPermissionGranted()) {
        for (var topic in subscribedTopics) {
          await _messaging.subscribeToTopic(topic);
        }
      }
      return true;
    } catch (e) {
      subscribedTopics.clear();
      return false;
    }
  }

  Future<bool> unsubscribeFromUserTopics() async {
    final user = appRepository.authRepository.userRole;
    if (user == null) {
      return false;
    }
    try {
      if (await isNotificationPermissionGranted()) {
        await _messaging.unsubscribeFromTopic('user_${user.info.id}');
        await _messaging.unsubscribeFromTopic('all_users');
        await _messaging.unsubscribeFromTopic('android_users');
        await _messaging.unsubscribeFromTopic('ios_users');
        await _messaging.unsubscribeFromTopic('masterAdmins');
        await _messaging.unsubscribeFromTopic('admins');
        await _messaging.unsubscribeFromTopic('companyManagers');
        await _messaging.unsubscribeFromTopic('branchManagers');
        await _messaging.unsubscribeFromTopic('employees');
        await _messaging.unsubscribeFromTopic('clients');
        if (user is CompanyManager) {
          await _messaging
              .unsubscribeFromTopic('companyManagers_${user.company.id}');
          await _messaging.unsubscribeFromTopic('company_${user.company.id}');
        }
        if (user is BranchManager || user is Employee || user is Client) {
          await _messaging
              .unsubscribeFromTopic('branchManagers_${user.branch.id}');
          await _messaging.unsubscribeFromTopic('employees_${user.branch.id}');
          await _messaging.unsubscribeFromTopic('branch_${user.branch.id}');
          await _messaging.unsubscribeFromTopic('clients_${user.branch.id}');
          await _messaging
              .unsubscribeFromTopic('company_${user.branch.company.id}');
        }
      }
      subscribedTopics.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}
