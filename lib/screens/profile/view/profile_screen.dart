import 'package:country_code_picker/country_code_picker.dart';
import 'package:fire_alarm_system/utils/data_validator_util.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/side_menu.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/alert.dart';
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
  bool _editMode = false;
  bool _isAuthorized = false;
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
        if (state is ProfileNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (Route<dynamic> route) => false,
            );
          });
        } else if (state is ProfileAuthenticated) {
          _user = state.user;
          _isAuthorized = state.isAuthorized;
          if (!_isAuthorized) {
            _showSideMenu = false;
          }
          if (state.error != null) {
            _editMode = false;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              CustomAlert.showError(
                context: context,
                title: Errors.getFirebaseErrorMessage(context, state.error!),
              );
              context.read<ProfileBloc>().add(AuthChanged());
            });
          } else if (state.message != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (state.message! == ProfileMessage.infoUpdated) {
                CustomAlert.showSuccess(
                  context: context,
                  title: S.of(context).info_updated,
                );
              } else if (state.message! ==
                  ProfileMessage.resetPasswordEmailSent) {
                CustomAlert.showSuccess(
                  context: context,
                  title: S.of(context).reset_email_sent,
                );
              }
              context.read<ProfileBloc>().add(AuthChanged());
            });
          }
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

    String selectedCountryCode =
        _user!.countryCode == "" ? '+966' : _user!.countryCode;
    nameController.value = TextEditingValue(text: _user!.name);
    emailController.value = TextEditingValue(text: _user!.email);
    phoneController.value = TextEditingValue(text: _user!.phoneNumber);

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).profile),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(RefreshRequested());
        },
        child: Row(
          children: [
            if (_showSideMenu || MediaQuery.of(context).size.width > 600)
              CustomSideMenu(
                highlightedItem: CustomSideMenuItem.profile,
                width: MediaQuery.of(context).size.width > 600
                    ? 300
                    : MediaQuery.of(context).size.width,
                user: _user!,
                noActionItems: const [
                  CustomSideMenuItem.profile,
                  CustomSideMenuItem.logout
                ],
                onItemClick: (item) async {
                  if (item == CustomSideMenuItem.logout) {
                    _showSideMenu = (MediaQuery.of(context).size.width > 600);
                    context.read<ProfileBloc>().add(LogoutRequested());
                  }
                  if (item == CustomSideMenuItem.profile) {
                    _showSideMenu = (MediaQuery.of(context).size.width > 600);
                    context.read<ProfileBloc>().add(RefreshRequested());
                  }
                },
              ),
            if (!_showSideMenu || MediaQuery.of(context).size.width > 600)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                            left: 16.0, right: 16.0, top: 8.0, bottom: 20.0),
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
                              DataValidator.validateName(context, value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 8.0, bottom: 20.0),
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
                              DataValidator.validateName(context, value),
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
                                enabled: _editMode,
                                onChanged: (countryCode) {
                                  selectedCountryCode =
                                      countryCode.dialCode ?? '+966';
                                },
                                padding: EdgeInsets.zero,
                                initialSelection: _user!.countryCode == ""
                                    ? 'SA'
                                    : _user!.countryCode,
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
                                    DataValidator.validatePhone(context, value),
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
                              _editMode = false;
                              context.read<ProfileBloc>().add(
                                  ChangeInfoRequested(
                                      name: nameController.text,
                                      countryCode: selectedCountryCode,
                                      phoneNumber: phoneController.text));
                            }
                          },
                          icon: Icon(_editMode ? Icons.save : Icons.edit,
                              color: Colors.white),
                          label: Text(
                            _editMode
                                ? S.of(context).save_changes
                                : S.of(context).edit_information,
                            style: _editMode
                                ? CustomStyle.normalButtonTextSmallWhite
                                : CustomStyle.normalButtonTextSmall,
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
                          icon: const Icon(Icons.key, color: Colors.white),
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
                            context.read<ProfileBloc>().add(LogoutRequested());
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: Text(
                            S.of(context).logout,
                            style: CustomStyle.normalButtonTextSmallWhite,
                          ),
                          style: CustomStyle.normalButtonRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
