import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:fire_alarm_system/models/user_auth.dart';

class AuthRepository {
  AuthRepository();

  final UserAuth _userAuth = UserAuth(authStatus: AuthStatus.notAuthenticated);

  void _setUserNotAuthenticated() {
    _userAuth.authStatus = AuthStatus.notAuthenticated;
    _userAuth.user = null;
  }

  Future<UserAuth> initAuth() async {
    print("TODO: Handle initAuth");
    await Future.delayed(const Duration(milliseconds: 500));
    if (false) {
      _userAuth.authStatus = AuthStatus.authenticatedWithEmailVerified;
      _userAuth.user = User(
          id: "112541",
          name: "Joh Doe",
          email: "example@example.com",
          countryCode: "+966",
          phoneNumber: "01014514855",
          role: UserRole.admin);
    } else {
      _setUserNotAuthenticated();
    }

    return _userAuth;
  }

  UserAuth getUserAuth() {
    return _userAuth;
  }

  Future<void> signOut() async {
    print("TODO: Handle signOut");
    await Future.delayed(const Duration(milliseconds: 500));
    _setUserNotAuthenticated();
  }

  Future<void> resendActivationEmail() async {
    print("TODO: Handle resendActivationEmail");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> sendPasswordResetEmail(String email) async {
    print("TODO: Handle sendPasswordResetEmail");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UserAuth> signInWithEmailAndPassword(
      String email, String password) async {
    String errorMessage = "";

    print("TODO: Handle signInWithEmailAndPassword");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _userAuth.authStatus = AuthStatus.authenticatedWithEmailNotVerified;
      _userAuth.user = User(
          id: "112541",
          name: "Joh Doe",
          email: "example@example.com",
          countryCode: "+966",
          phoneNumber: "01014514855",
          role: UserRole.admin);
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _userAuth;
  }

  Future<UserAuth> signInWithGoogle() async {
    String errorMessage = "";

    print("TODO: Handle signInWithGoogle");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _userAuth.authStatus = AuthStatus.authenticatedWithEmailVerified;
      _userAuth.user = User(
          id: "112541",
          name: "Joh Doe",
          email: "example@example.com",
          countryCode: "+966",
          phoneNumber: "01014514855",
          role: UserRole.admin);
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _userAuth;
  }

  Future<UserAuth> signInWithFacebook() async {
    String errorMessage = "This service is not available right now.";

    print("TODO: Handle signInWithFacebook");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _userAuth.authStatus = AuthStatus.authenticatedWithFacebook;
      _userAuth.user = User(
          id: "112541",
          name: "Joh Doe",
          email: "example@example.com",
          countryCode: "+966",
          phoneNumber: "01014514855",
          role: UserRole.admin);
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _userAuth;
  }

  Future<UserAuth> signUpWithEmailAndPassword(String email, String password,
      String name, String phone, String countryCode) async {
    String errorMessage = "";

    print("TODO: Handle signUpWithEmailAndPassword");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _userAuth.authStatus = AuthStatus.authenticatedWithEmailNotVerified;
      _userAuth.user = User(
          id: "112541",
          name: "Joh Doe",
          email: "example@example.com",
          countryCode: "+966",
          phoneNumber: "01014514855",
          role: UserRole.admin);
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _userAuth;
  }

  Future<UserAuth> signUpWithGoogle() async {
    String errorMessage = "";

    print("TODO: Handle signUpWithGoogle");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _userAuth.authStatus = AuthStatus.authenticatedWithGoogle;
      _userAuth.user = User(
          id: "112541",
          name: "Joh Doe",
          email: "example@example.com",
          countryCode: "+966",
          phoneNumber: "01014514855",
          role: UserRole.admin);
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _userAuth;
  }

  Future<UserAuth> signUpWithFacebook() async {
    String errorMessage = "This service is not available right now.";

    print("TODO: Handle signUpWithFacebook");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _userAuth.authStatus = AuthStatus.authenticatedWithFacebook;
      _userAuth.user = User(
          id: "112541",
          name: "Joh Doe",
          email: "example@example.com",
          countryCode: "+966",
          phoneNumber: "01014514855",
          role: UserRole.admin);
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _userAuth;
  }
}
