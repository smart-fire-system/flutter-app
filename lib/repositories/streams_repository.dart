import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/app_version.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/repositories/notifications_repository.dart';
import 'package:fire_alarm_system/repositories/user_repository.dart';

class Subscriptions {
  StreamSubscription? branches;
  StreamSubscription? companies;
  StreamSubscription? users;
  StreamSubscription? masterAdmins;
  StreamSubscription? admins;
  StreamSubscription? companyManagers;
  StreamSubscription? branchManagers;
  StreamSubscription? employees;
  StreamSubscription? clients;
  StreamSubscription? notifications;
  StreamSubscription? infoCollection;
  Subscriptions();
}

class Controllers {
  StreamController<void> users = StreamController<void>.broadcast();
  StreamController<void> notifications = StreamController<void>.broadcast();
  StreamController<void> infoCollection = StreamController<void>.broadcast();
  Controllers();
}

class StreamsRepository {
  final FirebaseFirestore _firestore;
  final AppRepository appRepository;
  final Subscriptions subscriptions = Subscriptions();
  final Controllers controllers = Controllers();
  bool _wasUserLoggedIn = false;

  StreamsRepository({required this.appRepository})
      : _firestore = FirebaseFirestore.instance {
    appRepository.authRepository.authStateChanges.listen((_) async {
      final wasLoggedIn = _wasUserLoggedIn;
      final isNowLoggedIn = appRepository.isUserReady();
      if ((isNowLoggedIn && !wasLoggedIn) || (wasLoggedIn && !isNowLoggedIn)) {
        cancelAllStreams();
      }
      _wasUserLoggedIn = isNowLoggedIn;
      if (!isNowLoggedIn) {
        _clearSnapshots();
      }
      startAllStreams(isLoggedIn: false);
      _updateAllDataStartingWith(UserRepository);
    }, onError: (error) {});
  }

  void _updateAllDataStartingWith(dynamic repository) {
    if (repository is BranchRepository) {
      appRepository.branchRepository.updateBranchesAndCompanies();
    } else if (repository is UserRepository) {
      appRepository.userRepository.getAllUsers();
    } else if (repository is NotificationsRepository) {
      appRepository.notificationsRepository.updateNotifications();
    } else if (repository is AppVersionData) {
      appRepository.updateInfoCollection();
    }
    appRepository.branchRepository.updateBranchesAndCompanies();
    appRepository.userRepository.getAllUsers();
    appRepository.notificationsRepository.updateNotifications();
    appRepository.updateInfoCollection();
    controllers.users.add(null);
    controllers.notifications.add(null);
    controllers.infoCollection.add(null);
  }

  void _clearSnapshots() {
    appRepository.branchRepository.branchesSnapshot = null;
    appRepository.branchRepository.companiesSnapshot = null;
    appRepository.userRepository.usersSnapshot = null;
    appRepository.userRepository.masterAdminsSnapshot = null;
    appRepository.userRepository.adminsSnapshot = null;
    appRepository.userRepository.companyManagersSnapshot = null;
    appRepository.userRepository.branchManagersSnapshot = null;
    appRepository.userRepository.employeesSnapshot = null;
    appRepository.userRepository.clientsSnapshot = null;
    appRepository.notificationsRepository.notificationsSnapshot = null;
    controllers.users.add(null);
    controllers.notifications.add(null);
    controllers.infoCollection.add(null);
  }

  void reStartAllStreams() {
    cancelAllStreams();
    startAllStreams();
  }

  void cancelAllStreams() {
    subscriptions.branches?.cancel();
    subscriptions.companies?.cancel();
    subscriptions.users?.cancel();
    subscriptions.masterAdmins?.cancel();
    subscriptions.admins?.cancel();
    subscriptions.companyManagers?.cancel();
    subscriptions.branchManagers?.cancel();
    subscriptions.employees?.cancel();
    subscriptions.clients?.cancel();
    subscriptions.notifications?.cancel();
  }

  void startAllStreams({isLoggedIn = true}) {
    if (!isLoggedIn) {
      subscriptions.infoCollection ??=
          _firestore.collection('info').snapshots().listen((snapshot) {
        appRepository.infoCollectionSnapshot = snapshot;
        _updateAllDataStartingWith(AppVersionData);
      });
      return;
    }
    subscriptions.branches =
        _firestore.collection('branches').snapshots().listen((snapshot) {
      appRepository.branchRepository.branchesSnapshot = snapshot;
      _updateAllDataStartingWith(BranchRepository);
    });
    subscriptions.companies =
        _firestore.collection('companies').snapshots().listen((snapshot) {
      appRepository.branchRepository.companiesSnapshot = snapshot;
      _updateAllDataStartingWith(BranchRepository);
    });
    subscriptions.users =
        _firestore.collection('users').snapshots().listen((snapshot) {
      appRepository.userRepository.usersSnapshot = snapshot;
      _updateAllDataStartingWith(UserRepository);
    });
    subscriptions.masterAdmins =
        _firestore.collection('masterAdmins').snapshots().listen((snapshot) {
      appRepository.userRepository.masterAdminsSnapshot = snapshot;
      _updateAllDataStartingWith(UserRepository);
    });
    subscriptions.admins =
        _firestore.collection('admins').snapshots().listen((snapshot) {
      appRepository.userRepository.adminsSnapshot = snapshot;
      _updateAllDataStartingWith(UserRepository);
    });
    subscriptions.companyManagers =
        _firestore.collection('companyManagers').snapshots().listen((snapshot) {
      appRepository.userRepository.companyManagersSnapshot = snapshot;
      _updateAllDataStartingWith(UserRepository);
    });
    subscriptions.branchManagers =
        _firestore.collection('branchManagers').snapshots().listen((snapshot) {
      appRepository.userRepository.branchManagersSnapshot = snapshot;
      _updateAllDataStartingWith(UserRepository);
    });
    subscriptions.employees =
        _firestore.collection('employees').snapshots().listen((snapshot) {
      appRepository.userRepository.employeesSnapshot = snapshot;
      _updateAllDataStartingWith(UserRepository);
    });
    subscriptions.clients =
        _firestore.collection('clients').snapshots().listen((snapshot) {
      appRepository.userRepository.clientsSnapshot = snapshot;
      _updateAllDataStartingWith(UserRepository);
    });
    subscriptions.notifications =
        _firestore.collection('notifications').snapshots().listen((snapshot) {
      appRepository.notificationsRepository.notificationsSnapshot = snapshot;
      _updateAllDataStartingWith(NotificationsRepository);
    });
  }
}
