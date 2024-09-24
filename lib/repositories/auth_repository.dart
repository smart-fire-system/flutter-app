import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:fire_alarm_system/models/user.dart';

class AuthRepository {
  AuthRepository();

  final User _user = User(authStatus: AuthStatus.notAuthenticated);

  void _setUserNotAuthenticated() {
    _user.authStatus = AuthStatus.notAuthenticated;
    _user.id = null;
    _user.name = null;
    _user.email = null;
    _user.phoneNumber = null;
    _user.countryCode = null;
    _user.role = null;
  }

  Future<User> initAuth() async {
    print("TODO: Handle initAuth");
    // TODO: Get Auth Info
    await Future.delayed(const Duration(milliseconds: 500));
    if (false) {
      _user.authStatus = AuthStatus.authenticatedWithEmailVerified;
      _user.role = UserRole.admin;
      _user.id = "112541";
      _user.name = "Joh Doe";
      _user.email = "example@example.com";
      _user.countryCode = "+966";
      _user.phoneNumber = "01014514855";
    } else {
      _setUserNotAuthenticated();
    }

    return _user;
  }

  User getUserInfo() {
    return _user;
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

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    String errorMessage = "";

    print("TODO: Handle signInWithEmailAndPassword");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _user.authStatus = AuthStatus.authenticatedWithEmailNotVerified;
      _user.role = UserRole.admin;
      _user.id = "112541";
      _user.name = "Joh Doe";
      _user.email = "example@example.com";
      _user.countryCode = "+966";
      _user.phoneNumber = "01014514855";
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _user;
  }

  Future<User> signInWithGoogle() async {
    String errorMessage = "";

    print("TODO: Handle signInWithGoogle");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _user.authStatus = AuthStatus.authenticatedWithEmailVerified;
      _user.role = UserRole.admin;
      _user.id = "112541";
      _user.name = "Joh Doe";
      _user.email = "example@example.com";
      _user.countryCode = "+966";
      _user.phoneNumber = "01014514855";
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _user;
  }

  Future<User> signInWithFacebook() async {
    String errorMessage = "This service is not available right now.";

    print("TODO: Handle signInWithFacebook");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _user.authStatus = AuthStatus.authenticatedWithFacebook;
      _user.role = UserRole.admin;
      _user.id = "112541";
      _user.name = "Joh Doe";
      _user.email = "example@example.com";
      _user.countryCode = "+966";
      _user.phoneNumber = "01014514855";
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _user;
  }

  Future<User> signUpWithEmailAndPassword(String email, String password,
      String name, String phone, String countryCode) async {
    String errorMessage = "";

    print("TODO: Handle signUpWithEmailAndPassword");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _user.authStatus = AuthStatus.authenticatedWithEmailNotVerified;
      _user.role = null;
      _user.id = "112541";
      _user.name = "Joh Doe";
      _user.email = "example@example.com";
      _user.countryCode = "+966";
      _user.phoneNumber = "01014514855";
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _user;
  }

  Future<User> signUpWithGoogle() async {
    String errorMessage = "";

    print("TODO: Handle signUpWithGoogle");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _user.authStatus = AuthStatus.authenticatedWithGoogle;
      _user.role = null;
      _user.id = "112541";
      _user.name = "Joh Doe";
      _user.email = "example@example.com";
      _user.countryCode = "+966";
      _user.phoneNumber = "01014514855";
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _user;
  }

  Future<User> signUpWithFacebook() async {
    String errorMessage = "This service is not available right now.";

    print("TODO: Handle signUpWithFacebook");
    await Future.delayed(const Duration(milliseconds: 500));

    if (errorMessage.isEmpty) {
      _user.authStatus = AuthStatus.authenticatedWithFacebook;
      _user.role = UserRole.admin;
      _user.id = "112541";
      _user.name = "Joh Doe";
      _user.email = "example@example.com";
      _user.countryCode = "+966";
      _user.phoneNumber = "01014514855";
    } else {
      _setUserNotAuthenticated();
      throw Exception(errorMessage);
    }
    return _user;
  }
}