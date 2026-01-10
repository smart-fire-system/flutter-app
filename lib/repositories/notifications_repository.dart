import 'dart:io';
import 'package:fire_alarm_system/models/notification.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsRepository {
  final FirebaseMessaging _messaging;
  final AppRepository _appRepository;
  final String _subscribedTopicsKey = 'subscribedTopics';
  final List<NotificationItem> _notifications = [];
  final List<String> _userTopics = [];
  bool? _notificationPermissionStatus;
  QuerySnapshot? notificationsSnapshot;
  NotificationsRepository({required AppRepository appRepository})
      : _appRepository = appRepository,
        _messaging = FirebaseMessaging.instance;

  List<NotificationItem> get notifications => _notifications;

  void refreshNotifications() {
    if (notificationsSnapshot == null) {
      _notifications.clear();
      return;
    }
    _notifications.clear();
    for (var doc in notificationsSnapshot!.docs) {
      final notification =
          NotificationItem.fromMap(doc.data() as Map<String, dynamic>);
      if (_userTopics.any((element) => notification.topics.contains(element))) {
        _notifications.add(notification);
      }
    }
    _notifications.sort((a, b) {
      final aDate = a.createdAt?.toDate();
      final bDate = b.createdAt?.toDate();
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
  }

  Future<bool?> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      _notificationPermissionStatus = true;
    }
    return _notificationPermissionStatus;
  }

  Future<bool> isSubscribedToUserTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final subscribedTopics = prefs.getStringList(_subscribedTopicsKey) ?? [];
    bool isSubscribed = subscribedTopics.length == _userTopics.length &&
        _userTopics.every((topic) => subscribedTopics.contains(topic)) &&
        subscribedTopics.every((topic) => _userTopics.contains(topic));
    if (!isSubscribed && subscribedTopics.isNotEmpty) {
      await unsubscribeFromUserTopics();
    }
    return isSubscribed;
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted || status.isLimited) {
      _notificationPermissionStatus = true;
    } else if (_notificationPermissionStatus == false) {
      openAppSettings();
    } else {
      _notificationPermissionStatus = false;
    }
  }

  Future<bool> setupUserToken() async {
    final token = await _messaging.getToken();
    if (_appRepository.authRepository.firebaseUser == null || token == null) {
      return false;
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(_appRepository.authRepository.firebaseUser!.uid)
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
          .doc(_appRepository.authRepository.firebaseUser!.uid)
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
    final user = _appRepository.authRepository.userRole;
    if (user == null) {
      return;
    }
    _userTopics.clear();
    _userTopics.add('user_${user.info.id}');
    _userTopics.add('all_users');
    if (Platform.isAndroid) {
      _userTopics.add('android_users');
    } else if (Platform.isIOS) {
      _userTopics.add('ios_users');
    }
    if (user is MasterAdmin) {
      _userTopics.add('masterAdmins');
    } else if (user is Admin) {
      _userTopics.add('admins');
    } else if (user is CompanyManager) {
      _userTopics.add('companyManagers');
      _userTopics.add('companyManagers_${user.company.id}');
      _userTopics.add('company_${user.company.id}');
    } else if (user is BranchManager) {
      _userTopics.add('branchManagers');
      _userTopics.add('branchManagers_${user.branch.id}');
      _userTopics.add('branch_${user.branch.id}');
      _userTopics.add('company_${user.branch.company.id}');
    } else if (user is Employee) {
      _userTopics.add('employees');
      _userTopics.add('employees_${user.branch.id}');
      _userTopics.add('branch_${user.branch.id}');
      _userTopics.add('company_${user.branch.company.id}');
    } else if (user is Client) {
      _userTopics.add('clients');
      _userTopics.add('clients_${user.branch.id}');
      _userTopics.add('branch_${user.branch.id}');
      _userTopics.add('company_${user.branch.company.id}');
    }
  }

  Future<void> subscribeToUserTopics() async {
    List<String> newSubscribedTopics = [];
    final prefs = await SharedPreferences.getInstance();
    final subscribedTopics = prefs.getStringList(_subscribedTopicsKey) ?? [];
    newSubscribedTopics = List.from(subscribedTopics);
    for (var topic in _userTopics) {
      if (!subscribedTopics.contains(topic)) {
        await _messaging.subscribeToTopic(topic);
        newSubscribedTopics.add(topic);
        prefs.setStringList(_subscribedTopicsKey, newSubscribedTopics);
      }
    }
    for (var topic in subscribedTopics) {
      if (!_userTopics.contains(topic)) {
        await _messaging.unsubscribeFromTopic(topic);
        newSubscribedTopics.remove(topic);
        prefs.setStringList(_subscribedTopicsKey, newSubscribedTopics);
      }
    }
  }

  Future<bool> unsubscribeFromUserTopics() async {
    try {
      final user = _appRepository.authRepository.userRole;
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_subscribedTopicsKey, []);
      return true;
    } catch (e) {
      return false;
    }
  }
}
