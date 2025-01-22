import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatelessWidget {
  final void Function() onLoginClick;
  final void Function() onSignUpClick;
  final void Function() onGoogleLoginClick;
  const WelcomeScreen({
    super.key,
    required this.onLoginClick,
    required this.onSignUpClick,
    required this.onGoogleLoginClick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).app_name),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 50.0),
                    child: Image.asset(
                      'assets/images/logo/2.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        onLoginClick();
                      },
                      style: CustomStyle.normalButton,
                      child: Text(
                        S.of(context).login,
                        style: CustomStyle.normalButtonText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        onSignUpClick();
                      },
                      style: CustomStyle.normalButton,
                      child: Text(
                        S.of(context).signup,
                        style: CustomStyle.normalButtonText,
                      ),
                    ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
