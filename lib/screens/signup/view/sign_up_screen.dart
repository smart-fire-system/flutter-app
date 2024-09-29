import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/data_validator_util.dart';
import 'package:fire_alarm_system/screens/signup/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/signup/bloc/event.dart';
import 'package:fire_alarm_system/screens/signup/bloc/state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SignUpBloc>().add(ResetStateRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      if (state is SignUpInitial) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<SignUpBloc>().add(AuthRequested());
        });
      } else if (state is SignUpNotAuthenticated) {
        if (state.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            CustomAlert.showError(context, state.error!);
            context.read<SignUpBloc>().add(AuthRequested());
          });
        }
        return _buildSignUpScreen(context);
      } else if (state is SignUpSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.popAndPushNamed(context, '/home');
          context.read<SignUpBloc>().add(ResetStateRequested());
        });
      }
      return const CustomLoading();
    });
  }

  Widget _buildSignUpScreen(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedCountryCode = '+966';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).signup,
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
                        S.of(context).signup_welcome,
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
                          labelText: S.of(context).name,
                          labelStyle: CustomStyle.smallText,
                          border: const OutlineInputBorder(),
                        ),
                        style: CustomStyle.smallText,
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
                          icon: const Icon(Icons.email),
                          labelText: S.of(context).email,
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
                              searchStyle: CustomStyle.smallText,
                              textStyle: CustomStyle.smallText,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                labelText: S.of(context).phone,
                                labelStyle: CustomStyle.smallText,
                                border: const OutlineInputBorder(),
                              ),
                              style: CustomStyle.smallText,
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
                          icon: const Icon(Icons.key),
                          labelText: S.of(context).password,
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
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textDirection: TextDirection.ltr,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.key),
                          labelText: S.of(context).confirm_password,
                          labelStyle: CustomStyle.smallText,
                          border: const OutlineInputBorder(),
                        ),
                        style: CustomStyle.smallText,
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
                            context.read<SignUpBloc>().add(SignUpRequested(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                phone: phoneController.text,
                                countryCode: selectedCountryCode));
                          }
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
                          context
                              .read<SignUpBloc>()
                              .add(GoogleSignUpRequested());
                        },
                        icon: const FaIcon(FontAwesomeIcons.google,
                            color: Colors.white),
                        label: Text(
                          S.of(context).signup_with_google,
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
                              .read<SignUpBloc>()
                              .add(FacebookSignUpRequested());
                        },
                        icon: const FaIcon(FontAwesomeIcons.facebook,
                            color: Colors.white),
                        label: Text(
                          S.of(context).signup_with_facebook,
                          style: CustomStyle.normalButtonTextSmall,
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
                        style: CustomStyle.smallText,
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
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
