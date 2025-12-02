import 'dart:io';
import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsRepository {
  final FirebaseMessaging _messaging;
  final AppRepository appRepository;
  List<NotificationItem> notifications = [];
  List<String> userTopics = [];
  bool isSubscribed = false;
  QuerySnapshot? notificationsSnapshot;
  bool _isSubscribing = false;
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
      if (userTopics.any((element) => notification.topics.contains(element))) {
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
    print('🔔 requestNotificationPermission');
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('🔔 settings: ${settings.authorizationStatus}');
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

  Future<void> updateUserTopics() async {
    final user = appRepository.authRepository.userRole;
    if (user == null) {
      return;
    }
    userTopics.clear();
    userTopics.add('user_${user.info.id}');
    userTopics.add('all_users');
    if (Platform.isAndroid) {
      userTopics.add('android_users');
    } else if (Platform.isIOS) {
      userTopics.add('ios_users');
    }
    if (user is MasterAdmin) {
      userTopics.add('masterAdmins');
    } else if (user is Admin) {
      userTopics.add('admins');
    } else if (user is CompanyManager) {
      userTopics.add('companyManagers');
      userTopics.add('companyManagers_${user.company.id}');
      userTopics.add('company_${user.company.id}');
    } else if (user is BranchManager) {
      userTopics.add('branchManagers');
      userTopics.add('branchManagers_${user.branch.id}');
      userTopics.add('branch_${user.branch.id}');
      userTopics.add('company_${user.branch.company.id}');
    } else if (user is Employee) {
      userTopics.add('employees');
      userTopics.add('employees_${user.branch.id}');
      userTopics.add('branch_${user.branch.id}');
      userTopics.add('company_${user.branch.company.id}');
    } else if (user is Client) {
      userTopics.add('clients');
      userTopics.add('clients_${user.branch.id}');
      userTopics.add('branch_${user.branch.id}');
      userTopics.add('company_${user.branch.company.id}');
    }
    subscribeToUserTopics();
  }

  Future<void> subscribeToUserTopics() async {
    if (_isSubscribing) {
      return;
    }
    _isSubscribing = true;
    const key = 'subscribedTopics';
    final prefs = await SharedPreferences.getInstance();
    final subscribedTopics = prefs.getStringList(key) ?? [];
    for (var topic in userTopics) {
      if (!subscribedTopics.contains(topic)) {
        await _messaging.subscribeToTopic(topic);
        subscribedTopics.add(topic);
        prefs.setStringList(key, subscribedTopics);
      }
    }
    for (var topic in subscribedTopics) {
      if (!userTopics.contains(topic)) {
        await _messaging.unsubscribeFromTopic(topic);
        subscribedTopics.remove(topic);
        prefs.setStringList(key, subscribedTopics);
      }
    }
    _isSubscribing = false;
  }

  Future<bool> unsubscribeFromUserTopics() async {
    try {
      final user = appRepository.authRepository.userRole;
      String userId = user == null ? '' : user.info.id;
      String companyId =
          user == null || user is! CompanyManager ? '' : user.company.id!;
      String branchId = user == null ||
              !(user is BranchManager || user is Employee || user is Client)
          ? ''
          : user.branch.id!;
      await _messaging.unsubscribeFromTopic('user_$userId');
      await _messaging.unsubscribeFromTopic('all_users');
      await _messaging.unsubscribeFromTopic('android_users');
      await _messaging.unsubscribeFromTopic('ios_users');
      await _messaging.unsubscribeFromTopic('masterAdmins');
      await _messaging.unsubscribeFromTopic('admins');
      await _messaging.unsubscribeFromTopic('companyManagers');
      await _messaging.unsubscribeFromTopic('branchManagers');
      await _messaging.unsubscribeFromTopic('employees');
      await _messaging.unsubscribeFromTopic('clients');
      await _messaging.unsubscribeFromTopic('companyManagers_$companyId');
      await _messaging.unsubscribeFromTopic('branchManagers_$branchId');
      await _messaging.unsubscribeFromTopic('employees_$branchId');
      await _messaging.unsubscribeFromTopic('clients_$branchId');
      await _messaging.unsubscribeFromTopic('company_$companyId');
      await _messaging.unsubscribeFromTopic('branch_$branchId');
      return true;
    } catch (e) {
      return false;
    }
  }
}
