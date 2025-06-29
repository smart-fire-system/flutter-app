import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/models/user_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final UserAuth _userAuth;
  final AppRepository appRepository;
  String? googleUserName;
  String? googleUserEmail;

  AuthRepository({required this.appRepository})
      : _firebaseAuth = firebase.FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        _userAuth = UserAuth(
          authStatus: AuthStatus.notAuthenticated,
        );

  AuthStatus get authStatus => _userAuth.authStatus;
  UserInfo get userInfo => _userAuth.userRole.info as UserInfo;
  dynamic get userRole => _userAuth.userRole;

  Stream<String?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        _setUserNotAuthenticated();
        return null;
      }

      if (firebaseUser.emailVerified) {
        _userAuth.authStatus = AuthStatus.authenticated;
      } else {
        _userAuth.authStatus = AuthStatus.authenticatedNotVerified;
      }

      try {
        await _checkUserExists();
        return null;
      } catch (e) {
        await signOut();
        if (e is FirebaseException) {
          return e.code;
        } else {
          return e.toString();
        }
      }
    });
  }

  Future<void> refreshUserAuth() async {
    await _firebaseAuth.currentUser?.reload();
    firebase.User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      _setUserNotAuthenticated();
    } else {
      await _checkUserExists();
    }
  }

  Future<void> signOut() async {
    firebase.User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      for (firebase.UserInfo info in firebaseUser.providerData) {
        if (info.providerId == 'google.com') {
          final googleSignIn = GoogleSignIn(
            clientId:
                '808637869294-4qf1i65a60knbo1673hsh7is34nj0rs0.apps.googleusercontent.com',
            scopes: ['email', 'profile'],
          );
          await googleSignIn.signOut();
        }
      }
      await _firebaseAuth.signOut();
      _setUserNotAuthenticated();
    }
  }

  Future<void> resendActivationEmail() async {
    try {
      firebase.User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await _firebaseAuth
            .setLanguageCode(LocalizationUtil.myLocale.languageCode);
        await user.sendEmailVerification();
      }
    } catch (e) {
      if (e is firebase.FirebaseAuthException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> sendPasswordResetEmail() async {
    if (_firebaseAuth.currentUser == null) {
      return;
    }
    try {
      await _firebaseAuth
          .setLanguageCode(LocalizationUtil.myLocale.languageCode);
      await _firebaseAuth.sendPasswordResetEmail(
          email: _firebaseAuth.currentUser!.email!);
    } catch (e) {
      if (e is firebase.FirebaseAuthException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    googleUserName = null;
    googleUserEmail = null;
    try {
      _userAuth.authStatus = AuthStatus.notAuthenticated;
      _userAuth.userRole = null;
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _setUserNotAuthenticated();
      if (e is firebase.FirebaseAuthException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    googleUserName = null;
    googleUserEmail = null;
    try {
      _userAuth.authStatus = AuthStatus.notAuthenticated;
      _userAuth.userRole = null;
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firebaseAuth.currentUser!.updateDisplayName(name);
      await _firebaseAuth
          .setLanguageCode(LocalizationUtil.myLocale.languageCode);
      await _firebaseAuth.currentUser!.sendEmailVerification();
    } catch (e) {
      _setUserNotAuthenticated();
      if (e is firebase.FirebaseAuthException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await GoogleSignIn(
        clientId:
            '808637869294-4qf1i65a60knbo1673hsh7is34nj0rs0.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      ).signIn();
    } catch (e) {
      _setUserNotAuthenticated();
      if (e is PlatformException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }

    try {
      if (googleUser == null) {
        throw PlatformException(code: 'sign_in_cancelled');
      }
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      googleUserName = googleUser.displayName;
      googleUserEmail = googleUser.email;
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      _setUserNotAuthenticated();
      if (e is firebase.FirebaseAuthException) {
        throw Exception(e.code);
      } else if (e is PlatformException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  void _setUserNotAuthenticated() {
    _userAuth.authStatus = AuthStatus.notAuthenticated;
    _userAuth.userRole = null;
    googleUserName = null;
    googleUserEmail = null;
  }

  Future<void> _checkUserExists() async {
    final user = _firebaseAuth.currentUser!;
    UserInfo userInfo = UserInfo(
      id: user.uid,
    );
    final documentSnapshot =
        await _firestore.collection('users').doc(userInfo.id).get();
    if (documentSnapshot.exists) {
      userInfo.name = documentSnapshot.get('name');
      userInfo.email = documentSnapshot.get('email');
      userInfo.countryCode = documentSnapshot.get('countryCode');
      userInfo.phoneNumber = documentSnapshot.get('phoneNumber');
      userInfo.createdAt = documentSnapshot.get('createdAt');
    } else {
      userInfo.name = googleUserName ?? user.displayName ?? "";
      userInfo.email = googleUserEmail ?? user.email ?? "";
      googleUserName = null;
      googleUserEmail = null;
      await _addUserToFirestore(userInfo);
    }
    _userAuth.userRole = await _getRoleUser(userInfo);
    // TODO: Remove this in production
    if (userInfo.email.endsWith("@test.com")) {
      _userAuth.authStatus = AuthStatus.authenticated;
    }
  }

  Future<dynamic> _getRoleUser(UserInfo user) async {
    QuerySnapshot querySnapshot;

    querySnapshot = await _firestore.collection('masterAdmins').get();
    if (appRepository.userRepository.isMasterAdmin(user.id, querySnapshot)) {
      return MasterAdmin(
        info: user,
      );
    }

    querySnapshot = await _firestore.collection('admins').get();
    AppPermissions? adminData =
        appRepository.userRepository.isAdmin(user.id, querySnapshot);
    if (adminData != null) {
      return Admin(
        info: user,
        permissions: adminData,
      );
    }

    querySnapshot = await _firestore.collection('companyManagers').get();
    Map<String, dynamic>? companyManagerData =
        appRepository.userRepository.isCompanyManager(user.id, querySnapshot);
    if (companyManagerData != null) {
      Map<String, dynamic>? companyData =
          await appRepository.branchRepository.getCompanyAndBranches(
        companyManagerData['id'],
      );
      if (companyData == null) {
        return NoRoleUser(info: user);
      }
      Company company = companyData['company'];
      List<Branch> branches = companyData['branches'];
      return CompanyManager(
        info: user,
        company: company,
        branches: branches,
        permissions: companyManagerData['permissions'],
      );
    }

    querySnapshot = await _firestore.collection('branchManagers').get();
    Map<String, dynamic>? branchManagerData =
        appRepository.userRepository.isBranchManager(user.id, querySnapshot);
    if (branchManagerData != null) {
      Branch? branch = await appRepository.branchRepository.getBranch(
        branchManagerData['id'],
      );
      if (branch == null) {
        return NoRoleUser(info: user);
      }
      return BranchManager(
        info: user,
        branch: branch,
        permissions: branchManagerData['permissions'],
      );
    }

    querySnapshot = await _firestore.collection('employees').get();
    Map<String, dynamic>? employeeData =
        appRepository.userRepository.isEmployee(user.id, querySnapshot);
    if (employeeData != null) {
      Branch? branch = await appRepository.branchRepository.getBranch(
        employeeData['id'],
      );
      if (branch == null) {
        return NoRoleUser(info: user);
      }
      return Employee(
        info: user,
        branch: branch,
        permissions: employeeData['permissions'],
      );
    }

    querySnapshot = await _firestore.collection('clients').get();
    Map<String, dynamic>? clientData =
        appRepository.userRepository.isClient(user.id, querySnapshot);
    if (clientData != null) {
      Branch? branch = await appRepository.branchRepository.getBranch(
        clientData['id'],
      );
      if (branch == null) {
        return NoRoleUser(info: user);
      }
      return Client(
        info: user,
        branch: branch,
        permissions: clientData['permissions'],
      );
    }

    return NoRoleUser(info: user);
  }

  Future<void> _addUserToFirestore(UserInfo userInfo) async {
    final firebaseUser = _firebaseAuth.currentUser;
    Map<String, dynamic> userData = {
      ...userInfo.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('users').doc(firebaseUser!.uid).set(userData);
  }
}
