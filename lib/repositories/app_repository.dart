import 'dart:async';

import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/repositories/system_repository.dart';
import 'package:fire_alarm_system/repositories/user_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppRepository {
  final FirebaseFirestore _firestore;
  late final AuthRepository _authRepository;
  late final BranchRepository _branchRepository;
  late final UserRepository _userRepository;
  late final SystemRepository _systemRepository;
  BranchesAndCompanies _branchesAndCompanies =
      BranchesAndCompanies(branches: [], companies: []);
  Users _users = Users();
  final _usersController = StreamController<void>.broadcast();
  final _branchesAndCompaniesController =
      StreamController<void>.broadcast();

  AppRepository() : _firestore = FirebaseFirestore.instance {
    _userRepository = UserRepository(appRepository: this);
    _authRepository = AuthRepository(appRepository: this);
    _branchRepository = BranchRepository(appRepository: this);
    _systemRepository = SystemRepository();
    _authRepository.authStateChanges.listen((data) async {
      if (data == null) {
        _branchesAndCompanies = _branchRepository.getBranchesAndCompanies();
        _branchesAndCompaniesController.add(null);
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
      }
    }, onError: (error) {});

    _firestore.collection('branches').snapshots().listen((snapshot) {
      _branchRepository.branchesSnapshot = snapshot;
      _branchesAndCompanies = _branchRepository.getBranchesAndCompanies();
      _branchesAndCompaniesController.add(null);
    });
    _firestore.collection('companies').snapshots().listen((snapshot) {
      _branchRepository.companiesSnapshot = snapshot;
      _branchesAndCompanies = _branchRepository.getBranchesAndCompanies();
      _branchesAndCompaniesController.add(null);
    });
    _firestore.collection('users').snapshots().listen((snapshot) {
      _userRepository.usersSnapshot = snapshot;
      try {
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
      } catch (e) {
        //print(e);
      }
    });
    _firestore.collection('masterAdmins').snapshots().listen((snapshot) {
      _userRepository.masterAdminsSnapshot = snapshot;
      try {
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
      } catch (e) {
        //print(e);
      }
    });
    _firestore.collection('admins').snapshots().listen((snapshot) {
      _userRepository.adminsSnapshot = snapshot;
      try {
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
      } catch (e) {
        //print(e);
      }
    });
    _firestore.collection('companyManagers').snapshots().listen((snapshot) {
      _userRepository.companyManagersSnapshot = snapshot;
      try {
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
      } catch (e) {
        //print(e);
      }
    });
    _firestore.collection('branchManagers').snapshots().listen((snapshot) {
      _userRepository.branchManagersSnapshot = snapshot;
      try {
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
      } catch (e) {
        //print(e);
      }
    });
    _firestore.collection('employees').snapshots().listen((snapshot) {
      _userRepository.employeesSnapshot = snapshot;
      try {
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
      } catch (e) {
        //print(e);
      }
    });
    _firestore.collection('clients').snapshots().listen((snapshot) {
      _userRepository.clientsSnapshot = snapshot;
      try {
        _users = _userRepository.getAllUsers();
        _usersController.add(null);
      } catch (e) {
        //print(e);
      }
    });
  }
  AuthStatus get authStatus => _authRepository.authStatus;
  Stream<String?> get authStateStream => _authRepository.authStateChanges;
  Stream<void> get branchesAndCompaniesStream =>
      _branchesAndCompaniesController.stream;
  Stream<void> get usersStream => _usersController.stream;
  List<Branch> get branches => _branchesAndCompanies.branches;
  List<Company> get companies => _branchesAndCompanies.companies;
  UserInfo get userInfo => _authRepository.userRole.info as UserInfo;
  dynamic get userRole => _authRepository.userRole;
  Users get users => _users;
  BranchRepository get branchRepository => _branchRepository;
  UserRepository get userRepository => _userRepository;
  AuthRepository get authRepository => _authRepository;
  SystemRepository get systemRepository => _systemRepository;
}
