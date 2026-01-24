import 'dart:async';

import 'package:fire_alarm_system/models/app_version.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/info_collection.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/repositories/notifications_repository.dart';
import 'package:fire_alarm_system/repositories/reports_repository.dart';
import 'package:fire_alarm_system/repositories/streams_repository.dart';
import 'package:fire_alarm_system/repositories/system_repository.dart';
import 'package:fire_alarm_system/repositories/user_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AppError {
  noError,
  networkError,
  generalError,
}

class AppRepository {
  late final AuthRepository _authRepository;
  late final BranchRepository _branchRepository;
  late final UserRepository _userRepository;
  late final SystemRepository _systemRepository;
  late final ReportsRepository _reportsRepository;
  late final NotificationsRepository _notificationsRepository;
  late final StreamsRepository _streamsRepository;
  QuerySnapshot? infoCollectionSnapshot;
  final _appStreamDataController = StreamController<AppError>.broadcast();
  InfoCollection? _infoCollection;

  AppRepository() {
    _userRepository = UserRepository(appRepository: this);
    _authRepository = AuthRepository(appRepository: this);
    _branchRepository = BranchRepository(appRepository: this);
    _systemRepository = SystemRepository();
    _reportsRepository = ReportsRepository(appRepository: this);
    _notificationsRepository = NotificationsRepository(appRepository: this);
    _streamsRepository = StreamsRepository(appRepository: this);
    _streamsRepository.controllers.users.stream.listen((_) {
      _appStreamDataController.add(AppError.noError);
    });
    _streamsRepository.controllers.notifications.stream.listen((_) {
      _appStreamDataController.add(AppError.noError);
    });
    _streamsRepository.controllers.infoCollection.stream.listen((_) {
      _appStreamDataController.add(AppError.noError);
    });
  }

  AuthStatus get authStatus => _authRepository.authStatus;
  Stream<AppError> get appStream => _appStreamDataController.stream;
  UserInfo get userInfo => _authRepository.userRole.info as UserInfo;
  dynamic get userRole => _authRepository.userRole;
  AppPermissions get permissions => _authRepository.userRole.permissions;
  Users get users => _userRepository.users;
  List<UserInfo> get allUsers => _userRepository.users.allUsers;
  List<MasterAdmin> get masterAdmins => _userRepository.users.masterAdmins;
  List<Admin> get admins => _userRepository.users.admins;
  List<CompanyManager> get companyManagers =>
      _userRepository.users.companyManagers;
  List<BranchManager> get branchManagers =>
      _userRepository.users.branchManagers;
  List<Employee> get employees => _userRepository.users.employees;
  List<Client> get clients => _userRepository.users.clients;
  List<NoRoleUser> get noRoleUsers => _userRepository.users.noRoleUsers;
  AppVersionData? get appVersionData => _infoCollection?.appVersionData;
  List<Branch> get branches => _branchRepository.branches;
  List<Company> get companies => _branchRepository.companies;

  BranchRepository get branchRepository => _branchRepository;
  UserRepository get userRepository => _userRepository;
  AuthRepository get authRepository => _authRepository;
  SystemRepository get systemRepository => _systemRepository;
  ReportsRepository get reportsRepository => _reportsRepository;
  NotificationsRepository get notificationsRepository =>
      _notificationsRepository;

  bool isUserReady() {
    return (_authRepository.authChangeStatus == AuthChangeResult.noError &&
        authStatus == AuthStatus.authenticated &&
        userRole != null &&
        userRole is! NoRoleUser &&
        userRole.info.phoneNumber.isNotEmpty);
  }

  void updateInfoCollection() {
    if (infoCollectionSnapshot != null) {
      _infoCollection = InfoCollection.fromSnapshot(infoCollectionSnapshot!);
    }
  }
}
