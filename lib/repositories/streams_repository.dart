import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/info_collection.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:rxdart/rxdart.dart';


class StreamsRepository {
  final FirebaseFirestore _firestore;
  final AppRepository _appRepository;
  StreamSubscription? combinedUsersBranchesSubscription;
  StreamSubscription? infoCollectionSubscription;
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
        await combinedUsersBranchesSubscription?.cancel();
        combinedUsersBranchesSubscription = null;
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
    infoCollectionSubscription ??=
        _firestore.collection('info').snapshots().listen((snapshot) {
      _appRepository.infoCollection = InfoCollection.fromSnapshot(snapshot);
      _updateAllData();
    });
    if (isLoggedIn) {
      await _subscribeToUsersAndBranches();
    }
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
    if (combinedUsersBranchesSubscription == null) {
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

    await combinedUsersBranchesSubscription?.cancel();
    combinedUsersBranchesSubscription = null;

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

    final branches$ = branchesQuery.snapshots();
    final companies$ = companiesQuery.snapshots();
    final users$ = usersQuery.snapshots();
    final masterAdmins$ = masterAdminsQuery.snapshots();
    final admins$ = adminsQuery.snapshots();
    final companyManagers$ = companyManagersQuery.snapshots();
    final branchManagers$ = branchManagersQuery.snapshots();
    final employees$ = employeesQuery.snapshots();
    final clients$ = clientsQuery.snapshots();

    combinedUsersBranchesSubscription = Rx.combineLatest9(
      branches$,
      companies$,
      users$,
      masterAdmins$,
      admins$,
      companyManagers$,
      branchManagers$,
      employees$,
      clients$,
      (
        QuerySnapshot branchesSnapshot,
        QuerySnapshot companiesSnapshot,
        QuerySnapshot usersSnapshot,
        QuerySnapshot masterAdminsSnapshot,
        QuerySnapshot adminsSnapshot,
        QuerySnapshot companyManagersSnapshot,
        QuerySnapshot branchManagersSnapshot,
        QuerySnapshot employeesSnapshot,
        QuerySnapshot clientsSnapshot,
      ) {
        return (
          branchesSnapshot,
          companiesSnapshot,
          usersSnapshot,
          masterAdminsSnapshot,
          adminsSnapshot,
          companyManagersSnapshot,
          branchManagersSnapshot,
          employeesSnapshot,
          clientsSnapshot
        ); // Dart record
      },
    ).listen((all) {
      final (
        branchesSnapshot,
        companiesSnapshot,
        usersSnapshot,
        masterAdminsSnapshot,
        adminsSnapshot,
        companyManagersSnapshot,
        branchManagersSnapshot,
        employeesSnapshot,
        clientsSnapshot
      ) = all;

      _appRepository.branchRepository.branchesSnapshot = branchesSnapshot;
      _appRepository.branchRepository.companiesSnapshot = companiesSnapshot;
      _appRepository.userRepository.usersSnapshot = usersSnapshot;
      _appRepository.userRepository.masterAdminsSnapshot = masterAdminsSnapshot;
      _appRepository.userRepository.adminsSnapshot = adminsSnapshot;
      _appRepository.userRepository.companyManagersSnapshot =
          companyManagersSnapshot;
      _appRepository.userRepository.branchManagersSnapshot =
          branchManagersSnapshot;
      _appRepository.userRepository.employeesSnapshot = employeesSnapshot;
      _appRepository.userRepository.clientsSnapshot = clientsSnapshot;
      _updateAllData();
    }, onError: (_) {
      _addStreamEvent(AppError.networkError);
    });
    _subscribedUser = _appRepository.userRole;
  }
}
