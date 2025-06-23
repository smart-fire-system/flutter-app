import 'dart:async';

import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/repositories/user_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppRepository {
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;
  final BranchRepository _branchRepository;
  final UserRepository _userRepository;
  BranchesAndCompanies _branchesAndCompanies =
      BranchesAndCompanies(branches: [], companies: []);
  Users _users = Users();
  final _branchesAndCompaniesController =
      StreamController<BranchesAndCompanies>.broadcast();

  AppRepository()
      : _firestore = FirebaseFirestore.instance,
        _authRepository = AuthRepository(),
        _branchRepository = BranchRepository(),
        _userRepository = UserRepository() {
    _authRepository.authStateChanges.listen((data) async {
      if (data == null) {
        _users = await _userRepository.getAllUsers(
          _authRepository.userRole,
          _branchesAndCompanies.branches,
          _branchesAndCompanies.companies,
        );
      }
    }, onError: (error) {});

    _firestore.collection('branches').snapshots().listen((snapshot) {
      _branchRepository.branchesSnapshot = snapshot;
      _branchesAndCompanies = _branchRepository.getBranchesAndCompanies();
      _branchesAndCompaniesController.add(_branchesAndCompanies);
    });
    _firestore.collection('companies').snapshots().listen((snapshot) {
      _branchRepository.companiesSnapshot = snapshot;
      _branchesAndCompanies = _branchRepository.getBranchesAndCompanies();
      _branchesAndCompaniesController.add(_branchesAndCompanies);
    });
  }
  AuthStatus get authStatus => _authRepository.authStatus;
  Stream<String?> get authStateStream => _authRepository.authStateChanges;
  Stream<BranchesAndCompanies> get branchesAndCompaniesStream =>
      _branchesAndCompaniesController.stream;
  List<Branch> get branches => _branchesAndCompanies.branches;
  List<Company> get companies => _branchesAndCompanies.companies;
  UserInfo get userInfo => _authRepository.userRole.info as UserInfo;
  dynamic get userRole => _authRepository.userRole;
  Users get users => _users;
  BranchRepository get branchRepository => _branchRepository;
  UserRepository get userRepository => _userRepository;
  AuthRepository get authRepository => _authRepository;
}
