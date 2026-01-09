import 'dart:io';

import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/data_validator_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fire_alarm_system/utils/app_version.dart';

class SignUpScreen extends StatelessWidget {
  final void Function(String name, String email, String password) onSignUpClick;
  final void Function() onGoogleLoginClick;
  final void Function() onLoginClick;
  const SignUpScreen({
    super.key,
    required this.onSignUpClick,
    required this.onLoginClick,
    required this.onGoogleLoginClick,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: l10n.signup),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 50.0),
                      child: Text(
                        l10n.signup_welcome,
                        style: CustomStyle.largeText30,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: l10n.name,
                          labelStyle: CustomStyle.smallText,
                          border: const OutlineInputBorder(),
                        ),
                        style: CustomStyle.smallText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: TextFormField(
                        controller: emailController,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.email),
                          labelText: l10n.email,
                          labelStyle: CustomStyle.smallText,
                          border: const OutlineInputBorder(),
                        ),
                        style: CustomStyle.smallText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: TextFormField(
                        controller: passwordController,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.key),
                          labelText: l10n.password,
                          labelStyle: CustomStyle.smallText,
                          border: const OutlineInputBorder(),
                        ),
                        style: CustomStyle.smallText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        textDirection: TextDirection.ltr,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.key),
                          labelText: l10n.confirm_password,
                          labelStyle: CustomStyle.smallText,
                          border: const OutlineInputBorder(),
                        ),
                        style: CustomStyle.smallText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            CustomAlert.showError(
                              context: context,
                              title: l10n.enter_name,
                            );
                          } else if (!DataValidator()
                              .isValidEmail(emailController.text)) {
                            CustomAlert.showError(
                              context: context,
                              title: l10n.valid_email,
                            );
                          } else if (passwordController.text.length < 6) {
                            CustomAlert.showError(
                              context: context,
                              title: l10n.password_length,
                            );
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            CustomAlert.showError(
                              context: context,
                              title: l10n.password_mismatch,
                            );
                          } else {
                            onSignUpClick(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        },
                        style: CustomStyle.normalButton,
                        child: Text(
                          l10n.signup,
                          style: CustomStyle.normalButtonText,
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        l10n.already_have_an_account,
                        style: CustomStyle.smallText,
                      ),
                      onPressed: () {
                        onLoginClick();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
                      child: Row(
                        children: <Widget>[
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              l10n.or,
                              style: CustomStyle.smallText,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          onGoogleLoginClick();
                        },
                        icon: const FaIcon(FontAwesomeIcons.google,
                            color: Colors.white),
                        label: Text(
                          l10n.continue_with_google,
                          style: CustomStyle.normalButtonTextSmallWhite,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(Platform.isAndroid ? androidAppVersion : iosAppVersion, style: CustomStyle.smallTextGrey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
