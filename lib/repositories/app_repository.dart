import 'dart:async';

import 'package:fire_alarm_system/models/app_version.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/repositories/notifications_repository.dart';
import 'package:fire_alarm_system/repositories/reports_repository.dart';
import 'package:fire_alarm_system/repositories/system_repository.dart';
import 'package:fire_alarm_system/repositories/user_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/utils/error_logger.dart';

class AppRepository {
  final FirebaseFirestore _firestore;
  late final AuthRepository _authRepository;
  late final BranchRepository _branchRepository;
  late final UserRepository _userRepository;
  late final SystemRepository _systemRepository;
  late final ReportsRepository _reportsRepository;
  late final NotificationsRepository _notificationsRepository;
  late final AppVersionData _appVersionData;
  AuthChangeResult _authChangeStatus = AuthChangeResult.generalError;
  BranchesAndCompanies _branchesAndCompanies =
      BranchesAndCompanies(branches: [], companies: []);
  Users _users = Users();
  final _usersController = StreamController<void>.broadcast();
  final _branchesAndCompaniesController = StreamController<void>.broadcast();
  final _notificationsController = StreamController<void>.broadcast();
  final _appVersionDataController = StreamController<void>.broadcast();

  // Stream subscriptions for Firestore listeners
  StreamSubscription? _branchesSubscription;
  StreamSubscription? _companiesSubscription;
  StreamSubscription? _usersSubscription;
  StreamSubscription? _masterAdminsSubscription;
  StreamSubscription? _adminsSubscription;
  StreamSubscription? _companyManagersSubscription;
  StreamSubscription? _branchManagersSubscription;
  StreamSubscription? _employeesSubscription;
  StreamSubscription? _clientsSubscription;
  StreamSubscription? _notificationsSubscription;
  StreamSubscription? _appVersionSubscription;
  bool _wasUserLoggedIn = false;

  AppRepository() : _firestore = FirebaseFirestore.instance {
    _userRepository = UserRepository(appRepository: this);
    _authRepository = AuthRepository(appRepository: this);
    _branchRepository = BranchRepository(appRepository: this);
    _systemRepository = SystemRepository();
    _reportsRepository = ReportsRepository(appRepository: this);
    _notificationsRepository = NotificationsRepository(appRepository: this);
    _authRepository.authStateChanges.listen((status) async {
      final wasLoggedIn = _wasUserLoggedIn;
      _authChangeStatus = status;

      // Check if user just logged in (was logged out before and is now ready)
      final isNowLoggedIn = isUserReady();

      if (isNowLoggedIn) {
        // If user just logged in (wasn't logged in before), reinitialize all streams
        if (!wasLoggedIn) {
          _reinitializeFirestoreListeners();
        }
        _branchesAndCompanies = _branchRepository.getBranchesAndCompanies();
        _branchesAndCompaniesController.add(null);
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
        _notificationsRepository.updateUserTopics();
        _notificationsRepository.refreshNotifications();
        _notificationsController.add(null);
      } else if (wasLoggedIn && !isNowLoggedIn) {
        // User just logged out - clear the snapshots
        _clearSnapshots();
      }

      _wasUserLoggedIn = isNowLoggedIn;
    }, onError: (error) {});

    // Initialize Firestore listeners
    _initializeFirestoreListeners();
  }

  void _initializeFirestoreListeners() {
    _branchesSubscription =
        _firestore.collection('branches').snapshots().listen((snapshot) {
      _branchRepository.branchesSnapshot = snapshot;
      _branchesAndCompanies = _branchRepository.getBranchesAndCompanies();
      _branchesAndCompaniesController.add(null);
      _authRepository.refreshUserAuth();
    });
    _companiesSubscription =
        _firestore.collection('companies').snapshots().listen((snapshot) {
      _branchRepository.companiesSnapshot = snapshot;
      _branchesAndCompanies = _branchRepository.getBranchesAndCompanies();
      _branchesAndCompaniesController.add(null);
      _authRepository.refreshUserAuth();
    });
    _usersSubscription =
        _firestore.collection('users').snapshots().listen((snapshot) {
      _userRepository.usersSnapshot = snapshot;
      _users = _userRepository.getAllUsers();
      _usersController.add(null);
      _authRepository.refreshUserAuth();
    });
    _masterAdminsSubscription =
        _firestore.collection('masterAdmins').snapshots().listen((snapshot) {
      _userRepository.masterAdminsSnapshot = snapshot;
      _users = _userRepository.getAllUsers();
      _usersController.add(null);
      _authRepository.refreshUserAuth();
    });
    _adminsSubscription =
        _firestore.collection('admins').snapshots().listen((snapshot) {
      _userRepository.adminsSnapshot = snapshot;
      _users = _userRepository.getAllUsers();
      _usersController.add(null);
      _authRepository.refreshUserAuth();
    });
    _companyManagersSubscription =
        _firestore.collection('companyManagers').snapshots().listen((snapshot) {
      _userRepository.companyManagersSnapshot = snapshot;
      _users = _userRepository.getAllUsers();
      _usersController.add(null);
      _authRepository.refreshUserAuth();
    });
    _branchManagersSubscription =
        _firestore.collection('branchManagers').snapshots().listen((snapshot) {
      _userRepository.branchManagersSnapshot = snapshot;
      _users = _userRepository.getAllUsers();
      _usersController.add(null);
      _authRepository.refreshUserAuth();
    });
    _employeesSubscription =
        _firestore.collection('employees').snapshots().listen((snapshot) {
      _userRepository.employeesSnapshot = snapshot;
      _users = _userRepository.getAllUsers();
      _usersController.add(null);
      _authRepository.refreshUserAuth();
    });
    _clientsSubscription =
        _firestore.collection('clients').snapshots().listen((snapshot) {
      _userRepository.clientsSnapshot = snapshot;
      _users = _userRepository.getAllUsers();
      _usersController.add(null);
      _authRepository.refreshUserAuth();
    });
    _notificationsSubscription =
        _firestore.collection('notifications').snapshots().listen((snapshot) {
      _notificationsRepository.notificationsSnapshot = snapshot;
      _notificationsRepository.updateUserTopics();
      _notificationsRepository.refreshNotifications();
      _notificationsController.add(null);
    });
    _appVersionSubscription = _firestore
        .collection('info')
        .doc('appVersion')
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        return;
      }
      _updateAppVersionData(snapshot.data() as Map<String, dynamic>);
      _appVersionDataController.add(null);
    });
  }

  void _cancelAllSubscriptions() {
    _branchesSubscription?.cancel();
    _companiesSubscription?.cancel();
    _usersSubscription?.cancel();
    _masterAdminsSubscription?.cancel();
    _adminsSubscription?.cancel();
    _companyManagersSubscription?.cancel();
    _branchManagersSubscription?.cancel();
    _employeesSubscription?.cancel();
    _clientsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    _appVersionSubscription?.cancel();
  }

  void _reinitializeFirestoreListeners() {
    _cancelAllSubscriptions();
    _initializeFirestoreListeners();
  }

  void _clearSnapshots() {
    _branchRepository.branchesSnapshot = null;
    _branchRepository.companiesSnapshot = null;
    _userRepository.usersSnapshot = null;
    _userRepository.masterAdminsSnapshot = null;
    _userRepository.adminsSnapshot = null;
    _userRepository.companyManagersSnapshot = null;
    _userRepository.branchManagersSnapshot = null;
    _userRepository.employeesSnapshot = null;
    _userRepository.clientsSnapshot = null;
    _notificationsRepository.notificationsSnapshot = null;
    _branchesAndCompanies = BranchesAndCompanies(branches: [], companies: []);
    _users = Users();
    _branchesAndCompaniesController.add(null);
    _usersController.add(null);
    _notificationsController.add(null);
  }

  AuthStatus get authStatus => _authRepository.authStatus;
  Stream<AuthChangeResult> get authStateStream =>
      _authRepository.authStateChanges;
  Stream<void> get branchesAndCompaniesStream =>
      _branchesAndCompaniesController.stream;
  Stream<void> get usersStream => _usersController.stream;
  Stream<void> get notificationsStream => _notificationsController.stream;
  Stream<void> get appVersionDataStream => _appVersionDataController.stream;
  List<Branch> get branches => _branchesAndCompanies.branches;
  List<Company> get companies => _branchesAndCompanies.companies;
  UserInfo get userInfo => _authRepository.userRole.info as UserInfo;
  dynamic get userRole => _authRepository.userRole;
  AppPermissions get permissions => _authRepository.userRole.permissions;
  Users get users => _users;
  List<UserInfo> get allUsers => _users.allUsers;
  List<MasterAdmin> get masterAdmins => _users.masterAdmins;
  List<Admin> get admins => _users.admins;
  List<CompanyManager> get companyManagers => _users.companyManagers;
  List<BranchManager> get branchManagers => _users.branchManagers;
  List<Employee> get employees => _users.employees;
  List<Client> get clients => _users.clients;
  List<NoRoleUser> get noRoleUsers => _users.noRoleUsers;
  AppVersionData get appVersionData => _appVersionData;

  BranchRepository get branchRepository => _branchRepository;
  UserRepository get userRepository => _userRepository;
  AuthRepository get authRepository => _authRepository;
  SystemRepository get systemRepository => _systemRepository;
  ReportsRepository get reportsRepository => _reportsRepository;
  NotificationsRepository get notificationsRepository =>
      _notificationsRepository;

  bool isUserReady() {
    return (_authChangeStatus == AuthChangeResult.noError &&
        authStatus == AuthStatus.authenticated &&
        userRole != null &&
        userRole is! NoRoleUser &&
        userRole.info.phoneNumber.isNotEmpty);
  }

  void _updateAppVersionData(Map<String, dynamic> data) {
    try {
      Map<String, dynamic> androidData = data['android'] ?? {};
      Map<String, dynamic> iosData = data['ios'] ?? {};
      _appVersionData = AppVersionData(
        androidInfo: AppVersionInfo(
          updateMessageAr: androidData['info']?['updateMessageAr'] ?? '',
          updateMessageEn: androidData['info']?['updateMessageEn'] ?? '',
          isAppAvailable: androidData['info']?['isAppAvailable'] ?? false,
        ),
        iosInfo: AppVersionInfo(
          updateMessageAr: iosData['info']?['updateMessageAr'] ?? '',
          updateMessageEn: iosData['info']?['updateMessageEn'] ?? '',
          isAppAvailable: iosData['info']?['isAppAvailable'] ?? false,
        ),
        latestAndroid: AppVersion(
          major: androidData['latest']?['major'] ?? 0,
          minor: androidData['latest']?['minor'] ?? 0,
          patch: androidData['latest']?['patch'] ?? 0,
          buildNumber: androidData['latest']?['buildNumber'] ?? 0,
        ),
        minimumAndroid: AppVersion(
          major: androidData['minimum']?['major'] ?? 0,
          minor: androidData['minimum']?['minor'] ?? 0,
          patch: androidData['minimum']?['patch'] ?? 0,
          buildNumber: androidData['minimum']?['buildNumber'] ?? 0,
        ),
        latestIos: AppVersion(
          major: iosData['latest']?['major'] ?? 0,
          minor: iosData['latest']?['minor'] ?? 0,
          patch: iosData['latest']?['patch'] ?? 0,
          buildNumber: iosData['latest']?['buildNumber'] ?? 0,
        ),
        minimumIos: AppVersion(
          major: iosData['minimum']?['major'] ?? 0,
          minor: iosData['minimum']?['minor'] ?? 0,
          patch: iosData['minimum']?['patch'] ?? 0,
          buildNumber: iosData['minimum']?['buildNumber'] ?? 0,
        ),
      );
    } catch (e) {
      ErrorLogger.log(e, StackTrace.current, 'checkAppVersion');
    }
  }
}
