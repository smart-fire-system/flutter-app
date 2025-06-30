import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/profile/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/profile/bloc/event.dart';
import 'package:fire_alarm_system/screens/profile/bloc/state.dart';
import 'package:fire_alarm_system/utils/data_validator_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/utils/alert.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String? name;
  final String? phoneNumber;
  final String? countryCode;
  const UpdateProfileScreen(
      {super.key, this.name, this.phoneNumber, this.countryCode});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  UserInfo? info;
  String _countryCode = '+966';

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileBloc>().state is ProfileAuthenticated
        ? (context.read<ProfileBloc>().state as ProfileAuthenticated).user
        : null;
    info = user?.info as UserInfo?;
    _nameController = TextEditingController(text: info?.name ?? '');
    _phoneController = TextEditingController(text: info?.phoneNumber ?? '');
    _countryCode =
        info?.countryCode.isNotEmpty == true ? info!.countryCode : '+966';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileBloc>().add(
            ChangeInfoRequested(
              name: _nameController.text.trim(),
              countryCode: _countryCode,
              phoneNumber: _phoneController.text.trim(),
            ),
          );
    }
  }

  void _onResetPassword() {
    context.read<ProfileBloc>().add(ResetPasswordRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileAuthenticated) {
          setState(() {
            info = state.user?.info as UserInfo?;
          });
          _nameController = TextEditingController(text: info?.name ?? '');
          _phoneController =
              TextEditingController(text: info?.phoneNumber ?? '');
          _countryCode =
              info?.countryCode.isNotEmpty == true ? info!.countryCode : '+966';

          AppLoading().dismiss(
            context: context,
            screen: AppScreen.updateProfile,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(
                context: context,
                title: state.error!,
              );
            } else if (state.message != null) {
              CustomAlert.showSuccess(
                context: context,
                title: state.message!.getText(context),
              );
              Navigator.pop(context);
            }
          });
        } else if (state is ProfileLoading) {
          if (state.updatingData) {
            AppLoading().show(
              context: context,
              screen: AppScreen.updateProfile,
              title: 'Please wait while we update your information',
              type: 'edit',
            );
          } else if (state.resettingPassword) {
            AppLoading().show(
              context: context,
              screen: AppScreen.updateProfile,
              title: 'Please wait while we reset your password',
            );
          } else if (state.loggingOut) {
            AppLoading().show(
              context: context,
              screen: AppScreen.updateProfile,
              title: 'Please wait while we log you out',
            );
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: S.of(context).edit_information),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _onSave(),
          backgroundColor: Colors.green,
          tooltip: S.of(context).edit_information,
          icon: const Icon(Icons.save),
          label: Text(S.of(context).save_changes),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: S.of(context).name,
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) =>
                      DataValidator.validateName(context, value),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (code) {
                        setState(() {
                          _countryCode = code.dialCode ?? '+966';
                        });
                      },
                      initialSelection: _countryCode,
                      favorite: const ['+966', 'SA'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      textStyle: CustomStyle.smallText,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: S.of(context).phone,
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) =>
                            DataValidator.validatePhone(context, value),
                      ),
                    ),
                  ],
                ),
                CustomNormalButton(
                  label: S.of(context).change_password,
                  onPressed: _onResetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
