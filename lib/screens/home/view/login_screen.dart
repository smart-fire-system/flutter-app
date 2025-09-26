import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fire_alarm_system/utils/app_version.dart';

class LoginScreen extends StatelessWidget {
  final void Function(String email, String password) onLoginClick;
  final void Function() onGoogleLoginClick;
  final void Function() onSignUpClick;
  final void Function() onResetPasswordClick;
  const LoginScreen({
    super.key,
    required this.onLoginClick,
    required this.onGoogleLoginClick,
    required this.onSignUpClick,
    required this.onResetPasswordClick,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).login),
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
                        S.of(context).login_welcome,
                        style: CustomStyle.largeText30,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: TextFormField(
                        controller: emailController,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          labelText: S.of(context).email,
                          icon: const Icon(Icons.email),
                          labelStyle: CustomStyle.smallText,
                          border: const OutlineInputBorder(),
                        ),
                        style: CustomStyle.smallText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 20.0),
                      child: TextFormField(
                        controller: passwordController,
                        textDirection: TextDirection.ltr,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
                          icon: const Icon(Icons.key),
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
                          onLoginClick(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                        style: CustomStyle.normalButton,
                        child: Text(
                          S.of(context).login,
                          style: CustomStyle.normalButtonText,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text(
                                S.of(context).forgot_password,
                                style: CustomStyle.smallText,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                onResetPasswordClick();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text(
                                S.of(context).don_t_have_an_account,
                                style: CustomStyle.smallText,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                onSignUpClick();
                              },
                            ),
                          ),
                        ),
                      ],
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
                              S.of(context).or,
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
                        icon: const Icon(FontAwesomeIcons.google,
                            color: Colors.white),
                        label: Text(
                          S.of(context).continue_with_google,
                          style: CustomStyle.normalButtonTextSmallWhite,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(appVersion, style: CustomStyle.smallTextGrey),
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
