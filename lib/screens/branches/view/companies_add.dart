import 'dart:io';

import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/utils/image_compress.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:fire_alarm_system/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});
  @override
  AddCompanyScreenState createState() => AddCompanyScreenState();
}

class AddCompanyScreenState extends State<AddCompanyScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _commentController;
  File? _newLogoFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(builder: (context, state) {
      AppLoading().dismiss(
        context: context,
        screen: AppScreen.addCompanies,
      );
      if (state is BranchesAuthenticated && state.canAddCompanies) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (state.error != null) {
            CustomAlert.showError(
              context: context,
              title: Errors.getFirebaseErrorMessage(context, state.error!),
            );
            state.error = null;
          } else if (state.message != null &&
              BranchesMessage.companyAdded == state.message) {
            state.message = null;
            CustomAlert.showSuccess(
              context: context,
              title: S.of(context).companyAdded,
            ).then((_) {
              if (context.mounted) {
                TabNavigator.settings.currentState?.popAndPushNamed(
                    '/company/details',
                    arguments: state.createdId as String);
                state.createdId = null;
              }
            });
          }
        });
        return _buildEditor(context);
      } else if (state is BranchesNotAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Navigator.pushNamed(context, '/signIn');
        });
      }
      return _buildLoading(context);
    });
  }

  Widget _buildEditor(BuildContext context) {
    AppLoading().dismiss(context: context, screen: AppScreen.addCompanies);
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).addCompany),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(S.of(context).save_changes,
            style: CustomStyle.mediumTextWhite),
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.save,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {
          _saveChanges(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                label: S.of(context).companyName,
                controller: _nameController,
              ),
              CustomTextField(
                label: S.of(context).address,
                controller: _addressController,
              ),
              CustomTextField(
                label: S.of(context).phone,
                controller: _phoneController,
                inputType: TextInputType.phone,
              ),
              CustomTextField(
                label: S.of(context).email,
                controller: _emailController,
                inputType: TextInputType.emailAddress,
              ),
              CustomTextField(
                label: S.of(context).comment,
                controller: _commentController,
                maxLines: 3,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () async {
                            File? file = await AppImage.pickImage();
                            setState(() {
                              _newLogoFile = file;
                            });
                          },
                          child: _newLogoFile != null
                              ? Image.file(
                                  _newLogoFile!,
                                  width: 150,
                                )
                              : Center(
                                  child: Text(
                                    S.of(context).tabToAddLogo,
                                    style: CustomStyle.mediumTextB,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: -3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      color: Colors.white,
                      child: Text(
                        S.of(context).companyLogo,
                        style: CustomStyle.smallTextBRed,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context) async {
    if (_nameController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterCompanyName,
      );
      return;
    } else if (_addressController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterCompanyAddress,
      );
      return;
    } else if (_phoneController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterCompanyPhone,
      );
      return;
    } else if (_emailController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterCompanyEmail,
      );
      return;
    } else if (_newLogoFile == null) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterCompanyLogo,
      );
      return;
    }

    int? confirm = await CustomAlert.showConfirmation(
      context: context,
      title: S.of(context).addCompany,
      subtitle: S.of(context).companyModifyWarning,
      buttons: [
        CustomAlertConfirmationButton(
          title: S.of(context).yesSaveChanges,
          value: 0,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        ),
        CustomAlertConfirmationButton(
          title: S.of(context).noCancel,
          value: 1,
          backgroundColor: CustomStyle.greyDark,
          textColor: Colors.white,
        ),
      ],
    );
    if (confirm == 0 && context.mounted) {
      AppLoading().show(
        context: context,
        screen: AppScreen.addCompanies,
        title: S.of(context).waitSavingCompany,
        type: 'add',
      );
      context.read<BranchesBloc>().add(CompanyAddRequested(
            logoFile: _newLogoFile!,
            company: Company(
              name: _nameController.text,
              address: _addressController.text,
              phoneNumber: _phoneController.text,
              email: _emailController.text,
              comment: _commentController.text,
              logoURL: "",
            ),
          ));
    }
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).addCompany),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => const CardLoading(
                  height: 80,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  margin: EdgeInsets.only(bottom: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
