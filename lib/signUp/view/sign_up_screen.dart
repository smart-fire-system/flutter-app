import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../generated/l10n.dart';
import '../../utils/localization_util.dart';
import '../../utils/data_validator_util.dart';
import '../../repositories/auth_repository.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).signup,
          style: GoogleFonts.cairo(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
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
      body: BlocProvider(
        create: (context) => SignUpBloc(authRepository: authRepository),
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            if (state is SignUpInitial) {
              EasyLoading.show(status: S.of(context).wait_while_loading);
              context.read<SignUpBloc>().add(AuthStatusRequested());
              return Container();
            } else if (state is SignUpLoading) {
              EasyLoading.show(status: S.of(context).signup_in_progress);
              return Container();
            } else if (state is SignUpFailure) {
              EasyLoading.dismiss();
              return Center(child: Text(state.error));
            } else if (state is SignUpSuccess) {
              EasyLoading.dismiss();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/home');
              });
            } else if (state is SignUpNotAuthenticated) {
              EasyLoading.dismiss();
            }
            return _buildSignUpForm(context);
          },
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedCountryCode = '+966';

    return Center(
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
                      S.of(context).signup_welcome,
                      style: GoogleFonts.cairo(
                          fontSize: 30.0, fontWeight: FontWeight.w500),
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
                        labelText: S.of(context).name,
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
                          DataValidator.validateName(context, value),
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
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: CountryCodePicker(
                            onChanged: (countryCode) {
                              selectedCountryCode =
                                  countryCode.dialCode ?? '+966';
                            },
                            padding: EdgeInsets.zero,
                            initialSelection: 'SA',
                            favorite: const ['SA'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            searchStyle: GoogleFonts.cairo(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            textStyle: GoogleFonts.cairo(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            textDirection: TextDirection.ltr,
                            decoration: InputDecoration(
                              labelText: S.of(context).phone,
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
                                DataValidator.validatePhone(context, value),
                          ),
                        ),
                      ],
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
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      textDirection: TextDirection.ltr,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: S.of(context).confirm_password,
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
                          DataValidator.validateConfirmPassword(
                              context, value, passwordController),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          context.read<SignUpBloc>().add(SignUpSubmitted(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              phone: phoneController.text,
                              countryCode: selectedCountryCode));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 151, 197, 160),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        S.of(context).signup,
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
                        context.read<SignUpBloc>().add(GoogleSignUpRequested());
                      },
                      icon: const FaIcon(FontAwesomeIcons.google,
                          color: Colors.white),
                      label: Text(
                        S.of(context).signup_with_google,
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
                            .read<SignUpBloc>()
                            .add(FacebookSignUpRequested());
                      },
                      icon: const FaIcon(FontAwesomeIcons.facebook,
                          color: Colors.white),
                      label: Text(
                        S.of(context).signup_with_facebook,
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
                      S.of(context).already_have_an_account,
                      style: GoogleFonts.cairo(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
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
