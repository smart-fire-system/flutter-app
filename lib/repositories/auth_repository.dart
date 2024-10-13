import 'package:fire_alarm_system/models/user.dart';
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

  AuthRepository()
      : _firebaseAuth = firebase.FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        _userAuth = UserAuth(authStatus: AuthStatus.notAuthenticated);

  UserAuth get userAuth => _userAuth;

  Stream<String> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        _setUserNotAuthenticated();
        return "";
      }

      if (firebaseUser.emailVerified) {
        _userAuth.authStatus = AuthStatus.authenticated;
      } else {
        _userAuth.authStatus = AuthStatus.authenticatedNotVerified;
      }

      try {
        await _validateUserRole();
        return "";
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

  Future<UserAuth> refreshUserAuth() async {
    await _firebaseAuth.currentUser?.reload();
    firebase.User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      _setUserNotAuthenticated();
    } else {
      await _validateUserRole();
    }
    return _userAuth;
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
      _setUserNotAuthenticated();
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
    try {
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

  Future<void> signUpWithEmailAndPassword(String email, String password,
      String name, String phoneNumber, String countryCode) async {
    try {
      _userAuth.user = User(
          id: "",
          name: name,
          email: email,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
          role: UserRole.noRole);
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

  Future<UserAuth> signInWithFacebook() async {
    _setUserNotAuthenticated();
    throw Exception('unavailable');
  }

  void _setUserNotAuthenticated() {
    _userAuth.authStatus = AuthStatus.notAuthenticated;
    _userAuth.user = null;
  }

  Future<void> _validateUserRole() async {
    _userAuth.user ??= User(
        id: _firebaseAuth.currentUser!.uid,
        name: "",
        email: "",
        countryCode: "",
        phoneNumber: "",
        role: UserRole.noRole);
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(_userAuth.user!.id).get();
    if (documentSnapshot.exists) {
      _userAuth.user!.name = documentSnapshot.get('name');
      _userAuth.user!.email = documentSnapshot.get('email');
      _userAuth.user!.countryCode = documentSnapshot.get('countryCode');
      _userAuth.user!.phoneNumber = documentSnapshot.get('phoneNumber');
      switch (documentSnapshot.get('role')) {
        case 'admin':
        case 'regionalManager':
        case 'branchManager':
        case 'employee':
        case 'technican':
        case 'client':
          try {
            DocumentSnapshot userRoleDocumentSnapshot = await FirebaseFirestore
                .instance
                .collection(documentSnapshot.get('role') + 's')
                .doc(_userAuth.user!.id)
                .get();
            if (userRoleDocumentSnapshot.exists) {
              _userAuth.user!.role = User.getRole(documentSnapshot.get('role'));
            } else {
              _userAuth.user!.role = UserRole.noRole;
              await _addUserToFirestore();
            }
          } catch (e) {
            if (e is FirebaseException) {
              if (e.code == 'permission-denied') {
                _userAuth.user!.role = UserRole.noRole;
                await _addUserToFirestore();
              } else {
                throw Exception(e.code);
              }
            } else {
              throw Exception(e.toString());
            }
          }
          break;
        default:
          _userAuth.user!.role = UserRole.noRole;
          break;
      }
    } else {
      await _addUserToFirestore();
    }
  }

  Future<void> _addUserToFirestore() async {
    firebase.User? firebaseUser = _firebaseAuth.currentUser;
    Map<String, dynamic> userData = {
      'name': firebaseUser!.displayName,
      'email': firebaseUser.email,
      'phoneNumber': _userAuth.user!.phoneNumber,
      'countryCode': _userAuth.user!.countryCode,
      'role': User.getRoleId(_userAuth.user!.role),
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('users').doc(firebaseUser.uid).set(userData);
  }
}
