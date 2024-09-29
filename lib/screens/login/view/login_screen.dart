import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/data_validator_util.dart';

import 'package:fire_alarm_system/screens/login/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/login/bloc/event.dart';
import 'package:fire_alarm_system/screens/login/bloc/state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(ResetStateRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<LoginBloc>().add(AuthRequested());
          });
        } else if (state is LoginNotAuthenticated) {
          if (state.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              CustomAlert.showError(context, state.error!);
              context.read<LoginBloc>().add(AuthRequested());
            });
          }
          return _buildLoginScreen(context);
        } else if (state is LoginSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.popAndPushNamed(context, '/home');
          });
        } else if (state is ResetEmailSent) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.error == null) {
              CustomAlert.showSuccess(context, S.of(context).reset_email_sent);
            } else {
              CustomAlert.showError(context, state.error!);
            }
            context.read<LoginBloc>().add(AuthRequested());
          });
        }
        return const CustomLoading();
      },
    );
  }

  Future<void> _resetPassword(BuildContext content) async {
    String email = "";
    await Alert(
      context: context,
      title: S.of(context).forgot_password,
      desc: S.of(context).enter_email_to_reset,
      type: AlertType.none,
      style: AlertStyle(
        titleStyle: CustomStyle.largeTextB,
        descStyle: CustomStyle.mediumText,
        animationType: AnimationType.grow,
      ),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: S.of(context).email,
                icon: const Icon(Icons.email),
                labelStyle: CustomStyle.smallText,
                border: const OutlineInputBorder(),
              ),
              style: CustomStyle.smallText,
              onChanged: (value) {
                email = value;
              },
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(S.of(context).ok, style: CustomStyle.normalButtonText),
          onPressed: () {
            if (email != "") {
              context
                  .read<LoginBloc>()
                  .add(ResetPasswordRequested(email: email));
              Navigator.pop(context);
            }
          },
        ),
        DialogButton(
          child:
              Text(S.of(context).cancel, style: CustomStyle.normalButtonText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }

  Widget _buildLoginScreen(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).login,
          style: CustomStyle.appBarText,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
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
                        validator: (value) =>
                            DataValidator.validateEmail(context, value),
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
                        validator: (value) =>
                            DataValidator.validatePassword(context, value),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<LoginBloc>().add(LoginRequested(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ));
                          }
                        },
                        style: CustomStyle.normalButton,
                        child: Text(
                          S.of(context).login,
                          style: CustomStyle.normalButtonText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        child: Text(
                          S.of(context).forgot_password,
                          style: CustomStyle.smallText,
                        ),
                        onPressed: () async {
                          _resetPassword(context);
                        },
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
                          context.read<LoginBloc>().add(GoogleLoginRequested());
                        },
                        icon: const Icon(FontAwesomeIcons.google,
                            color: Colors.white),
                        label: Text(
                          S.of(context).login_with_google,
                          style: CustomStyle.normalButtonTextSmall,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<LoginBloc>()
                              .add(FacebookLoginRequested());
                        },
                        icon: const FaIcon(FontAwesomeIcons.facebook,
                            color: Colors.white),
                        label: Text(
                          S.of(context).login_with_facebook,
                          style: CustomStyle.normalButtonTextSmall,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        child: Text(
                          S.of(context).don_t_have_an_account,
                          style: CustomStyle.smallText,
                        ),
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/signup');
                          context.read<LoginBloc>().add(ResetStateRequested());
                        },
                      ),
                    ),
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
