import 'dart:io';

import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/image_compress.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
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
  File? _newSignatureFile;
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
              signatureFile: _newSignatureFile,
            ),
          );
    }
  }

  void _onResetPassword() {
    context.read<ProfileBloc>().add(ResetPasswordRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        appBar: CustomAppBar(title: l10n.edit_information),
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final bool isUpdating =
                state is ProfileLoading && state.updatingData;
            return SafeArea(
              child: CustomNormalButton(
                label: l10n.save_changes,
                icon: Icons.save,
                backgroundColor: Colors.green,
                fullWidth: true,
                onPressed: isUpdating ? null : _onSave,
              ),
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                // Personal info
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal information',
                          style: CustomStyle.mediumTextB,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l10n.name,
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) =>
                              DataValidator.validateName(context, value),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Contact
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact',
                          style: CustomStyle.mediumTextB,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              height: 56,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: CountryCodePicker(
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
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  labelText: l10n.phone,
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) =>
                                    DataValidator.validatePhone(context, value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Signature
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await AppImage.pickImage();
                      if (picked != null) {
                        setState(() {
                          _newSignatureFile = picked;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.edit_document,
                                  color: Colors.blueGrey),
                              const SizedBox(width: 8),
                              Text('Signature', style: CustomStyle.smallTextB),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 80),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: _newSignatureFile != null
                                ? Image.file(_newSignatureFile!, height: 80)
                                : (info?.signatureUrl != "")
                                    ? Image.network(
                                        info?.signatureUrl ?? '',
                                        height: 80,
                                      )
                                    : const Text('Tap to add your signature'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Security
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: CustomNormalButton(
                      label: l10n.change_password,
                      icon: Icons.lock_reset,
                      onPressed: _onResetPassword,
                      fullWidth: true,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
