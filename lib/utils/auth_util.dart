import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthUtil {
  static void login({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    String email = emailController.text;
    String password = passwordController.text;
    if (kDebugMode) {
      print("Login: ");
      print(" - Email: $email");
      print(" - Password: $password");
    }
    /* TODO: Add Login Handling */
    //Navigator.pushNamed(context, '/home');
  }

  static void loginWithGoogle({
    required BuildContext context,
  }) {
    if (kDebugMode) {
      print("Login with Google");
    }
    /* TODO: Add Login with Google Handling */
    //Navigator.pushNamed(context, '/home');
  }

  static void loginWithFacebook({
    required BuildContext context,
  }) {
    if (kDebugMode) {
      print("Login with Facebook");
    }
    /* TODO: Add Login with Facebook Handling */
    //Navigator.pushNamed(context, '/home');
  }

  static void signUp({
    required BuildContext context,
    required String countryCode,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
  }) {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    if (kDebugMode) {
      print("Name: $name");
      print("Email: $email");
      print("Phone: $phone");
      print("Password: $password");
      print("Country Code: $countryCode");
    }
    /* TODO: Add Sign Up Handling */
    //Navigator.pushNamed(context, '/login');
  }

  static void signUpWithGoogle({
    required BuildContext context,
  }) {
    if (kDebugMode) {
      print("Sign Up with Google");
    }
    /* TODO: Add Sign Up with Google Handling */
    //Navigator.pushNamed(context, '/home');
  }

  static void signUpWithFacebook({
    required BuildContext context,
  }) {
    if (kDebugMode) {
      print("Sign Up with Facebook");
    }
    /* TODO: Add Sign Up with Facebook Handling */
    //Navigator.pushNamed(context, '/home');
  }
}
