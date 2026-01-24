import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/info_collection.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';

enum AppError {
  noError,
  networkError,
  generalError,
}

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
  StreamSubscription? infoCollection;
  Subscriptions();
}

class StreamsRepository {
  final FirebaseFirestore _firestore;
  final AppRepository _appRepository;
  final Subscriptions _subscriptions = Subscriptions();
  final StreamController<AppError> _appStream =
      StreamController<AppError>.broadcast();
  bool _wasUserLoggedIn = false;
  dynamic _subscribedUser = NoRoleUser(info: UserInfo(id: ''));
  AppError? _lastAppError;

  Stream<AppError> get appStream => _appStream.stream;
  AppError? get lastAppError => _lastAppError;

  StreamsRepository({required AppRepository appRepository})
      : _appRepository = appRepository,
        _firestore = FirebaseFirestore.instance {
    _appRepository.authRepository.authStateChanges.listen((_) async {
      final wasLoggedIn = _wasUserLoggedIn;
      final isNowLoggedIn = _appRepository.isUserReady();
      if ((isNowLoggedIn && !wasLoggedIn) || (wasLoggedIn && !isNowLoggedIn)) {
        _cancelAllStreams();
      }
      _wasUserLoggedIn = isNowLoggedIn;
      if (!isNowLoggedIn) {
        _clearSnapshots();
      }
      _startAllStreams(isLoggedIn: isNowLoggedIn);
      _updateAllData();
    }, onError: (error) {
      _addStreamEvent(AppError.networkError);
    });
  }

  Future<void> _startAllStreams({isLoggedIn = true}) async {
    _subscriptions.infoCollection ??=
        _firestore.collection('info').snapshots().listen((snapshot) {
      _appRepository.infoCollection = InfoCollection.fromSnapshot(snapshot);
      _updateAllData();
    });
    if (isLoggedIn) {
      await _subscribeToUsersAndBranches();
    }
  }

  Future<void> _cancelAllStreams() async {
    await _subscriptions.branches?.cancel();
    _subscriptions.branches = null;
    await _subscriptions.companies?.cancel();
    _subscriptions.companies = null;
    await _subscriptions.users?.cancel();
    _subscriptions.users = null;
    await _subscriptions.masterAdmins?.cancel();
    _subscriptions.masterAdmins = null;
    await _subscriptions.admins?.cancel();
    _subscriptions.admins = null;
    await _subscriptions.companyManagers?.cancel();
    _subscriptions.companyManagers = null;
    await _subscriptions.branchManagers?.cancel();
    _subscriptions.branchManagers = null;
    await _subscriptions.employees?.cancel();
    _subscriptions.employees = null;
    await _subscriptions.clients?.cancel();
    _subscriptions.clients = null;
  }

  void _addStreamEvent(AppError error) {
    _lastAppError = error;
    _appStream.add(error);
  }

  void _updateAllData() {
    _appRepository.branchRepository.updateBranchesAndCompanies();
    _appRepository.userRepository.getAllUsers();
    _addStreamEvent(AppError.noError);
  }

  void _clearSnapshots() {
    _appRepository.branchRepository.branchesSnapshot = null;
    _appRepository.branchRepository.companiesSnapshot = null;
    _appRepository.userRepository.usersSnapshot = null;
    _appRepository.userRepository.masterAdminsSnapshot = null;
    _appRepository.userRepository.adminsSnapshot = null;
    _appRepository.userRepository.companyManagersSnapshot = null;
    _appRepository.userRepository.branchManagersSnapshot = null;
    _appRepository.userRepository.employeesSnapshot = null;
    _appRepository.userRepository.clientsSnapshot = null;
    _addStreamEvent(AppError.noError);
  }

  bool _isSubscriptionNeeded() {
    final userRole = _appRepository.userRole;
    if (_subscriptions.branches == null ||
        _subscriptions.companies == null ||
        _subscriptions.masterAdmins == null ||
        _subscriptions.admins == null ||
        _subscriptions.companyManagers == null ||
        _subscriptions.branchManagers == null ||
        _subscriptions.employees == null ||
        _subscriptions.clients == null) {
      return true;
    }
    if (_subscribedUser?.runtimeType == userRole?.runtimeType) {
      if (userRole is MasterAdmin || userRole is Admin) {
        return false;
      } else if (userRole is CompanyManager) {
        if (userRole.company.id == _subscribedUser?.company.id) {
          return false;
        }
      } else if (userRole is BranchManager ||
          userRole is Employee ||
          userRole is Client) {
        if (userRole.branch.id == _subscribedUser?.branch.id) {
          return false;
        }
      } else {
        return false;
      }
    }
    return true;
  }

  Future<void> _subscribeToUsersAndBranches() async {
    if (!_isSubscriptionNeeded()) {
      return;
    }
    Query<Map<String, dynamic>> branchesQuery =
        _firestore.collection('branches').orderBy('code');
    Query<Map<String, dynamic>> companiesQuery =
        _firestore.collection('companies').orderBy('code');
    Query<Map<String, dynamic>> usersQuery =
        _firestore.collection('users').orderBy('name');
    Query<Map<String, dynamic>> masterAdminsQuery =
        _firestore.collection('masterAdmins');
    Query<Map<String, dynamic>> adminsQuery = _firestore.collection('admins');
    Query<Map<String, dynamic>> companyManagersQuery =
        _firestore.collection('companyManagers');
    Query<Map<String, dynamic>> branchManagersQuery =
        _firestore.collection('branchManagers');
    Query<Map<String, dynamic>> employeesQuery =
        _firestore.collection('employees');
    Query<Map<String, dynamic>> clientsQuery = _firestore.collection('clients');

    await _cancelAllStreams();

    if (_appRepository.userRole is MasterAdmin ||
        _appRepository.userRole is Admin) {
      /* Do Nothing */
    } else if (_appRepository.userRole is CompanyManager) {
      final companyId = _appRepository.userRole.company.id;
      branchesQuery = branchesQuery.where('company', isEqualTo: companyId);
      companiesQuery =
          companiesQuery.where(FieldPath.documentId, isEqualTo: companyId);
      companyManagersQuery =
          companyManagersQuery.where('company', isEqualTo: companyId);
      branchManagersQuery =
          branchManagersQuery.where('company', isEqualTo: companyId);
      employeesQuery = employeesQuery.where('company', isEqualTo: companyId);
      clientsQuery = clientsQuery.where('company', isEqualTo: companyId);
    } else if (_appRepository.userRole is BranchManager ||
        _appRepository.userRole is Employee ||
        _appRepository.userRole is Client) {
      final companyId = _appRepository.userRole.branch.company.id;
      final branchId = _appRepository.userRole.branch.id;
      branchesQuery =
          branchesQuery.where(FieldPath.documentId, isEqualTo: branchId);
      companiesQuery = companiesQuery.where(FieldPath.documentId,
          isEqualTo: _appRepository.userRole.branch.company.id);
      companyManagersQuery =
          companyManagersQuery.where('company', isEqualTo: companyId);
      branchManagersQuery =
          branchManagersQuery.where('branch', isEqualTo: branchId);
      employeesQuery = employeesQuery.where('branch', isEqualTo: branchId);
      clientsQuery = clientsQuery.where('branch', isEqualTo: branchId);
    } else {
      return;
    }
    _subscriptions.branches = branchesQuery.snapshots().listen((snapshot) {
      _appRepository.branchRepository.branchesSnapshot = snapshot;
      _updateAllData();
    });
    _subscriptions.companies = companiesQuery.snapshots().listen((snapshot) {
      _appRepository.branchRepository.companiesSnapshot = snapshot;
      _updateAllData();
    });
    _subscriptions.users = usersQuery.snapshots().listen((snapshot) {
      _appRepository.userRepository.usersSnapshot = snapshot;
      _updateAllData();
    });
    _subscriptions.masterAdmins =
        masterAdminsQuery.snapshots().listen((snapshot) {
      _appRepository.userRepository.masterAdminsSnapshot = snapshot;
      _updateAllData();
    });
    _subscriptions.admins = adminsQuery.snapshots().listen((snapshot) {
      _appRepository.userRepository.adminsSnapshot = snapshot;
      _updateAllData();
    });
    _subscriptions.companyManagers =
        companyManagersQuery.snapshots().listen((snapshot) {
      _appRepository.userRepository.companyManagersSnapshot = snapshot;
      _updateAllData();
    });
    _subscriptions.branchManagers =
        branchManagersQuery.snapshots().listen((snapshot) {
      _appRepository.userRepository.branchManagersSnapshot = snapshot;
      _updateAllData();
    });
    _subscriptions.employees = employeesQuery.snapshots().listen((snapshot) {
      _appRepository.userRepository.employeesSnapshot = snapshot;
      _updateAllData();
    });
    _subscriptions.clients = clientsQuery.snapshots().listen((snapshot) {
      _appRepository.userRepository.clientsSnapshot = snapshot;
      _updateAllData();
    });
    _subscribedUser = _appRepository.userRole;
  }
}
