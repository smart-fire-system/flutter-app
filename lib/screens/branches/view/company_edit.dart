import 'dart:io';

import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/utils/image_compress.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';

class EditCompanyScreen extends StatefulWidget {
  final String companyId;
  const EditCompanyScreen({
    super.key,
    required this.companyId,
  });

  @override
  EditCompanyScreenState createState() => EditCompanyScreenState();
}

class EditCompanyScreenState extends State<EditCompanyScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _commentController;
  List<Branch> _branches = [];
  AppPermissions _permissions = AppPermissions();
  bool _isFirstCall = true;
  Company? _company;
  File? _newLogoFile;

  @override
  void initState() {
    super.initState();
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
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        AppLoading().dismiss(
          context: context,
          screen: AppScreen.editCompanies,
        );
        if (state is BranchesAuthenticated && state.user.permissions.canEditCompanies) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(
                context: context,
                title: Errors.getFirebaseErrorMessage(context, state.error!),
              );
              state.error = null;
            } else if (state.message != null &&
                BranchesMessage.companyModified == state.message) {
              state.message = null;
              CustomAlert.showSuccess(
                context: context,
                title: l10n.companyModified,
              ).then((_) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              });
            }
          });
          if (BranchesMessage.companyDeleted == state.message) {
            state.message = null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          } else {
            _company = state.companies
                .firstWhere((company) => company.id == widget.companyId);
            _branches = List.from(state.branches);
            _permissions = state.user.permissions;
            if (_isFirstCall) {
              _isFirstCall = false;
              _nameController = TextEditingController(text: _company!.name);
              _addressController =
                  TextEditingController(text: _company!.address);
              _phoneController =
                  TextEditingController(text: _company!.phoneNumber);
              _emailController = TextEditingController(text: _company!.email);
              _commentController =
                  TextEditingController(text: _company!.comment);
            }
            return _buildEditor(context);
          }
        } else if (state is BranchesNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushNamed(context, '/signIn');
          });
        }
        return _buildLoading(context);
      },
    );
  }

  Widget _buildEditor(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    AppLoading().dismiss(context: context, screen: AppScreen.editCompanies);
    return Scaffold(
      appBar: CustomAppBar(title: l10n.editCompany),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(l10n.save_changes,
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
                label: l10n.companyName,
                controller: _nameController,
              ),
              CustomTextField(
                label: l10n.address,
                controller: _addressController,
              ),
              CustomTextField(
                label: l10n.phone,
                controller: _phoneController,
                inputType: TextInputType.phone,
              ),
              CustomTextField(
                label: l10n.email,
                controller: _emailController,
                inputType: TextInputType.emailAddress,
              ),
              CustomTextField(
                label: l10n.comment,
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
                            _newLogoFile = await AppImage.pickImage();
                          },
                          child: _newLogoFile != null
                              ? Image.file(
                                  _newLogoFile!,
                                  width: 150,
                                )
                              : Image.network(
                                  _company!.logoURL,
                                  width: 150,
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
                        l10n.companyLogo,
                        style: CustomStyle.smallTextBRed,
                      ),
                    ),
                  ),
                ],
              ),
              if (_permissions.canDeleteCompanies)
                CustomNormalButton(
                  label: l10n.deleteCompany,
                  backgroundColor: CustomStyle.redDark,
                  fullWidth: true,
                  onPressed: () {
                    _deleteCompany(context);
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (_nameController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: l10n.enterCompanyName,
      );
      return;
    } else if (_addressController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: l10n.enterCompanyAddress,
      );
      return;
    } else if (_phoneController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: l10n.enterCompanyPhone,
      );
      return;
    } else if (_emailController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: l10n.enterCompanyEmail,
      );
      return;
    }

    int? confirm = await CustomAlert.showConfirmation(
      context: context,
      title: l10n.editCompany,
      subtitle: l10n.companyModifyWarning,
      buttons: [
        CustomAlertConfirmationButton(
          title: l10n.yesSaveChanges,
          value: 0,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        ),
        CustomAlertConfirmationButton(
          title: l10n.noCancel,
          value: 1,
          backgroundColor: CustomStyle.greyDark,
          textColor: Colors.white,
        ),
      ],
    );
    if (confirm == 0 && context.mounted) {
      AppLoading().show(
        context: context,
        screen: AppScreen.editCompanies,
        title: l10n.waitSavingCompany,
        type: 'edit',
      );
      context.read<BranchesBloc>().add(CompanyModifyRequested(
            logoFile: _newLogoFile,
            company: Company(
                id: _company!.id,
                name: _nameController.text,
                address: _addressController.text,
                phoneNumber: _phoneController.text,
                email: _emailController.text,
                comment: _commentController.text,
                logoURL: _company!.logoURL),
          ));
    }
  }

  void _deleteCompany(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    int? confirm = await CustomAlert.showConfirmation(
      context: context,
      title: l10n.deleteCompany,
      subtitle: l10n.companyDeleteWarning,
      buttons: [
        CustomAlertConfirmationButton(
          title: l10n.yesDeleteCompany,
          value: 0,
          backgroundColor: CustomStyle.redDark,
          textColor: Colors.white,
        ),
        CustomAlertConfirmationButton(
          title: l10n.noCancel,
          value: 1,
          backgroundColor: CustomStyle.greyDark,
          textColor: Colors.white,
        ),
      ],
    );
    if (confirm == 0 && context.mounted) {
      AppLoading().show(
        context: context,
        screen: AppScreen.editCompanies,
        title: l10n.waitDeltingCompany,
        type: 'delete',
      );
      context.read<BranchesBloc>().add(
            CompanyDeleteRequested(
              id: _company!.id!,
              branches: _branches,
            ),
          );
    }
  }

  Widget _buildLoading(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: l10n.editCompany),
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
