import 'package:country_code_picker/country_code_picker.dart';
import 'package:fire_alarm_system/utils/data_validator_util.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/not_authenticated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/access_denied.dart';
import 'package:fire_alarm_system/widgets/side_menu.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/screens/profile/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/profile/bloc/event.dart';
import 'package:fire_alarm_system/screens/profile/bloc/state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool _showSideMenu = false;
  bool _userLoggedOut = false;
  bool _editMode = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _showSideMenu = (MediaQuery.of(context).size.width > 600);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileError) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            CustomAlert.showError(
                context, Errors.getFirebaseErrorMessage(context, state.error));
            context.read<ProfileBloc>().add(AuthChanged());
          });
        } else if (state is ProfileNotAuthenticated) {
          if (_userLoggedOut) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              Navigator.popAndPushNamed(context, '/welcome');
            });
          } else {
            return const CustomNotAuthenticated();
          }
        } else if (state is ProfileNotVerified) {
          _user = state.user;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
            } else if (state.emailSent == true) {
              CustomAlert.showSuccess(context, S.of(context).reset_email_sent);
            }
          });
          return CustomAccessDenied(
            user: _user!,
            type: AccessDeniedType.accountNeedsVerification,
            onLogoutClick: () async {
              _userLoggedOut = true;
              context.read<ProfileBloc>().add(LogoutRequested());
            },
            onResendClick: () async {
              context.read<ProfileBloc>().add(ResendEmailRequested());
            },
          );
        } else if (state is ProfileNoRole) {
          _user = state.user;
          if (state.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
            });
          }
          return CustomAccessDenied(
            user: _user!,
            type: AccessDeniedType.noRoleForUser,
            onLogoutClick: () async {
              _userLoggedOut = true;
              context.read<ProfileBloc>().add(LogoutRequested());
            },
          );
        } else if (state is ResetEmailSent) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            context.read<ProfileBloc>().add(AuthChanged());
            if (state.error == null) {
              CustomAlert.showSuccess(context, S.of(context).reset_email_sent);
            } else {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
            }
          });
        } else if (state is VerificationEmailSent) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            context.read<ProfileBloc>().add(AuthChanged());
            if (state.error == null) {
              CustomAlert.showSuccess(context, S.of(context).reset_email_sent);
            } else {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
            }
          });
        } else if (state is InfoUpdated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            _editMode = false;
            context.read<ProfileBloc>().add(AuthChanged());
            if (state.error == null) {
              CustomAlert.showSuccess(context, S.of(context).info_updated);
            } else {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
            }
          });
        } else if (state is ProfileAuthenticated) {
          _user = state.user;
          return _buildProfile(context);
        }
        return const CustomLoading();
      },
    );
  }

  Widget _buildProfile(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    String selectedCountryCode = '+966';
    nameController.value = TextEditingValue(text: _user!.name);
    emailController.value = TextEditingValue(text: _user!.email);
    phoneController.value = TextEditingValue(text: _user!.phoneNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).profile,
          style: CustomStyle.appBarText,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: _showSideMenu ? Colors.white : Colors.black,
          ),
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  _showSideMenu ? Colors.blueAccent : Colors.white)),
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _showSideMenu = !_showSideMenu;
              });
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _showSideMenu
                ? CustomSideMenu(
                    highlightedItem: CustomSideMenuItem.home,
                    user: _user!,
                    noActionItems: const [
                      CustomSideMenuItem.home,
                      CustomSideMenuItem.logout
                    ],
                    onItemClick: (item) async {
                      if (item == CustomSideMenuItem.logout) {
                        _userLoggedOut = true;
                        context.read<ProfileBloc>().add(LogoutRequested());
                      }
                    },
                  )
                : Container(),
            SizedBox(
              width: _showSideMenu
                  ? MediaQuery.of(context).size.width < 600
                      ? 300
                      : MediaQuery.of(context).size.width - 300
                  : MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (MediaQuery.of(context).size.width < 600 &&
                            _showSideMenu) {
                          setState(() {
                            _showSideMenu = false;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: ListView(
                            children: <Widget>[
                              const Icon(
                                Icons.account_circle,
                                size: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  User.getRoleName(context, _user!.role),
                                  style: CustomStyle.mediumTextB,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 8.0,
                                    bottom: 20.0),
                                child: TextFormField(
                                  enabled: _editMode,
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).name,
                                    icon: const Icon(Icons.person),
                                    labelStyle: CustomStyle.smallText,
                                    border: const OutlineInputBorder(),
                                  ),
                                  style: CustomStyle.smallText,
                                  validator: (value) =>
                                      DataValidator.validateName(
                                          context, value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 8.0,
                                    bottom: 20.0),
                                child: TextFormField(
                                  enabled: false,
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
                                      DataValidator.validateName(
                                          context, value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  children: <Widget>[
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: CountryCodePicker(
                                        enabled: _editMode,
                                        onChanged: (countryCode) {
                                          selectedCountryCode =
                                              countryCode.dialCode ?? '+966';
                                        },
                                        padding: EdgeInsets.zero,
                                        initialSelection: _user!.countryCode == ""? 'SA' : _user!.countryCode,
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
                                        enabled: _editMode,
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
                                            DataValidator.validatePhone(
                                                context, value),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_editMode == false) {
                                      setState(() {
                                        _editMode = true;
                                      });
                                    } else {
                                      context.read<ProfileBloc>().add(
                                          ChangeInfoRequested(
                                              name: nameController.text,
                                              countryCode: selectedCountryCode,
                                              phoneNumber:
                                                  phoneController.text));
                                    }
                                  },
                                  icon: Icon(
                                      _editMode ? Icons.save : Icons.edit,
                                      color: Colors.white),
                                  label: Text(
                                    _editMode
                                        ? S.of(context).save_changes
                                        : S.of(context).edit_information,
                                    style: CustomStyle.normalButtonTextSmall,
                                  ),
                                  style: _editMode
                                      ? CustomStyle.normalButtonGreen
                                      : CustomStyle.normalButton,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<ProfileBloc>()
                                        .add(ResetPasswordRequested());
                                  },
                                  icon: const Icon(Icons.key,
                                      color: Colors.white),
                                  label: Text(
                                    S.of(context).change_password,
                                    style: CustomStyle.normalButtonTextSmall,
                                  ),
                                  style: CustomStyle.normalButton,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _userLoggedOut = true;
                                    context
                                        .read<ProfileBloc>()
                                        .add(LogoutRequested());
                                  },
                                  icon: const Icon(Icons.logout,
                                      color: Colors.white),
                                  label: Text(
                                    S.of(context).logout,
                                    style: CustomStyle.normalButtonTextSmall,
                                  ),
                                  style: CustomStyle.normalButtonRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
