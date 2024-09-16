import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../generated/l10n.dart';
import '../utils/localization_util.dart';
import '../utils/auth_util.dart';

class SignUpScreen extends StatefulWidget {
  final Function(Locale) onLanguageChange;
  const SignUpScreen({required this.onLanguageChange, super.key});
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedCountryCode = '+966';

  String? _validateName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_name;
    }
    return null;
  }

  String? _validatePhone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_phone_number;
    }
    String pattern = r'^[0-9]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return S.of(context).valid_phone_number;
    }
    return null;
  }

  String? _validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_password;
    } else if (value.length < 6) {
      return S.of(context).password_length;
    }
    return null;
  }

  String? _validateConfirmPassword(BuildContext context, String? value,
      TextEditingController passwordController) {
    if (value == null || value.isEmpty) {
      return S.of(context).confirm_password;
    } else if (value != passwordController.text) {
      return S.of(context).password_mismatch;
    }
    return null;
  }

  String? _validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).enter_email;
    }
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return S.of(context).valid_email;
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signup),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(
                  context, widget.onLanguageChange);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.2,
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: S.of(context).name,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => _validateName(context, value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: S.of(context).email,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => _validateEmail(context, value),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        CountryCodePicker(
                          onChanged: (countryCode) {
                            setState(() {
                              _selectedCountryCode =
                                  countryCode.dialCode ?? '+966';
                            });
                          },
                          initialSelection: 'SA',
                          favorite: const ['SA'],
                          showCountryOnly: true,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: S.of(context).phone,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                _validatePhone(context, value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: S.of(context).password,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => _validatePassword(context, value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: S.of(context).confirm_password,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => _validateConfirmPassword(
                          context, value, _passwordController),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          AuthUtil.signUp(
                            countryCode: _selectedCountryCode,
                            nameController: _nameController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            passwordController: _passwordController,
                            context: context,
                          );
                        }
                      },
                      child: Text(S.of(context).signup),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(S.of(context).or),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        AuthUtil.signUpWithGoogle(context:context);
                      },
                      icon: const FaIcon(FontAwesomeIcons.google,
                          color: Colors.white),
                      label: Text(
                        S.of(context).signup_with_google,
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        AuthUtil.signUpWithFacebook(context:context);
                      },
                      icon: const FaIcon(FontAwesomeIcons.facebook,
                          color: Colors.white),
                      label: Text(
                        S.of(context).signup_with_facebook,
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      child: Text(S.of(context).already_have_an_account),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
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
