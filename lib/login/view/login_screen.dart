import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../generated/l10n.dart';
import '../../utils/localization_util.dart';
import '../../utils/data_validator_util.dart';
import '../../repositories/auth_repository.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class LoginScreen extends StatelessWidget {
  final Function(Locale) onLanguageChange;

  const LoginScreen({required this.onLanguageChange, super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).login,
          style: GoogleFonts.cairo(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(
                  context, onLanguageChange);
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(authRepository: authRepository),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginInitial) {
              EasyLoading.show(status: S.of(context).wait_while_loading);
              context.read<LoginBloc>().add(AuthStatusRequested());
              return Container();
            } else if (state is LoginLoading) {
              EasyLoading.show(status: S.of(context).logging_in_progress);
              return Container();
            } else if (state is LoginFailure) {
              EasyLoading.dismiss();
              return Center(child: Text(state.error));
            } else if (state is LoginSuccess) {
              EasyLoading.dismiss();
              print("Login Done");
              //Navigator.pushReplacementNamed(context, '/home');
            } else if (state is LoginNotAuthenticated) {
              EasyLoading.dismiss();
            }
            return _buildLoginForm(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: FractionallySizedBox(
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
                        style: GoogleFonts.cairo(
                            fontSize: 30.0, fontWeight: FontWeight.w500),
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
                          labelStyle: GoogleFonts.cairo(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          border: const OutlineInputBorder(),
                        ),
                        style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
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
                          labelStyle: GoogleFonts.cairo(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          border: const OutlineInputBorder(),
                        ),
                        style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
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
                            context.read<LoginBloc>().add(LoginSubmitted(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 151, 197, 160),
                          minimumSize: const Size(double.infinity, 50),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                        ),
                        child: Text(
                          S.of(context).login,
                          style: GoogleFonts.cairo(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
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
                              style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
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
                        icon: const FaIcon(FontAwesomeIcons.google,
                            color: Colors.white),
                        label: Text(
                          S.of(context).login_with_google,
                          style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
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
                          style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        S.of(context).don_t_have_an_account,
                        style: GoogleFonts.cairo(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
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
