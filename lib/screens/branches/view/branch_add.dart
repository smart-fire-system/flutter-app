import 'dart:io';

import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/utils/image_compress.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/dropdown.dart';
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

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({super.key});
  @override
  AddBranchScreenState createState() => AddBranchScreenState();
}

class AddBranchScreenState extends State<AddBranchScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _commentController;
  late TextEditingController _firstPartyNameController;
  late TextEditingController _firstPartyRepNameController;
  late TextEditingController _firstPartyAddressController;
  late TextEditingController _firstPartyCommercialRecordController;
  late TextEditingController _firstPartyGController;
  late TextEditingController _firstPartyIdNumberController;
  File? _firstPartySignatureFile;
  List<Company> _companies = [];
  Company? _selectedCompany;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _commentController = TextEditingController();
    _firstPartyNameController = TextEditingController();
    _firstPartyRepNameController = TextEditingController();
    _firstPartyAddressController = TextEditingController();
    _firstPartyCommercialRecordController = TextEditingController();
    _firstPartyGController = TextEditingController();
    _firstPartyIdNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _commentController.dispose();
    _firstPartyNameController.dispose();
    _firstPartyRepNameController.dispose();
    _firstPartyAddressController.dispose();
    _firstPartyCommercialRecordController.dispose();
    _firstPartyGController.dispose();
    _firstPartyIdNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(builder: (context, state) {
      AppLoading().dismiss(
        context: context,
        screen: AppScreen.addBranhes,
      );
      if (state is BranchesAuthenticated &&
          state.user.permissions.canAddBranches) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (state.error != null) {
            CustomAlert.showError(
              context: context,
              title: Errors.getFirebaseErrorMessage(context, state.error!),
            );
            state.error = null;
          } else if (state.message != null &&
              BranchesMessage.branchAdded == state.message) {
            state.message = null;
            CustomAlert.showSuccess(
              context: context,
              title: S.of(context).branchAdded,
            ).then((_) {
              if (context.mounted) {
                TabNavigator.usersAndBranches.currentState?.popAndPushNamed(
                    '/branch/details',
                    arguments: state.createdId as String);
                state.createdId = null;
              }
            });
          }
        });
        _companies = state.companies;
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
    AppLoading().dismiss(context: context, screen: AppScreen.addBranhes);
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).addBranch),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionCard(
                    context,
                    title: S.of(context).branchInformation,
                    icon: Icons.info_outline,
                    children: [
                      CustomTextField(
                        label: S.of(context).branchName,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: S.of(context).address,
                        controller: _addressController,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    context,
                    title: S.of(context).contactInformation,
                    icon: Icons.contact_phone_outlined,
                    children: [
                      CustomTextField(
                        label: S.of(context).phone,
                        controller: _phoneController,
                        inputType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: S.of(context).email,
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    context,
                    title: S.of(context).companyInformation,
                    icon: Icons.business_outlined,
                    children: [
                      CustomDropdownSingle(
                        title: S.of(context).company,
                        subtitle: S.of(context).changeCompany,
                        items: _companies.map((company) {
                          return CustomDropdownItem(
                            title: company.name,
                            value: company.id!,
                          );
                        }).toList(),
                        onChanged: (newCompany) {
                          _selectedCompany = _companies.firstWhere(
                              (company) => company.id == newCompany.value);
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: S.of(context).comment,
                        controller: _commentController,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    context,
                    title: 'First Party Information',
                    icon: Icons.person_outline,
                    children: [
                      CustomTextField(
                        label: 'First Party Name',
                        controller: _firstPartyNameController,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'First Party Representative Name',
                        controller: _firstPartyRepNameController,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'First Party Address',
                        controller: _firstPartyAddressController,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'First Party Commercial Record',
                        controller: _firstPartyCommercialRecordController,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'First Party G',
                        controller: _firstPartyGController,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'First Party ID Number',
                        controller: _firstPartyIdNumberController,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    context,
                    title: 'First Party Signature',
                    icon: Icons.edit,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () async {
                            final file = await AppImage.pickImage();
                            if (file != null) {
                              setState(() {
                                _firstPartySignatureFile = file;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_firstPartySignatureFile == null)
                                  const Icon(Icons.cloud_upload_outlined),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Center(
                                    child: _firstPartySignatureFile != null
                                        ? Image.file(
                                            _firstPartySignatureFile!,
                                            width: 180,
                                            fit: BoxFit.contain,
                                          )
                                        : Text(
                                            'Tap to upload signature',
                                            style: CustomStyle.mediumTextB,
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context) async {
    if (_nameController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterBranchName,
      );
      return;
    } else if (_addressController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterBranchAddress,
      );
      return;
    } else if (_phoneController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterBranchPhone,
      );
      return;
    } else if (_emailController.text.isEmpty) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterBranchEmail,
      );
      return;
    } else if (_selectedCompany == null) {
      CustomAlert.showError(
        context: context,
        title: S.of(context).enterBranchCompany,
      );
      return;
    }

    int? confirm = await CustomAlert.showConfirmation(
      context: context,
      title: S.of(context).addBranch,
      subtitle: S.of(context).branchModifyWarning,
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
        screen: AppScreen.addBranhes,
        title: S.of(context).waitSavingBranch,
        type: 'add',
      );
      context.read<BranchesBloc>().add(BranchAddRequested(
            branch: Branch(
              name: _nameController.text,
              address: _addressController.text,
              phoneNumber: _phoneController.text,
              email: _emailController.text,
              comment: _commentController.text,
              company: _selectedCompany!,
              contractFirstParty: ContractFirstParty(
                name: _firstPartyNameController.text,
                repName: _firstPartyRepNameController.text,
                address: _firstPartyAddressController.text,
                commercialRecord: _firstPartyCommercialRecordController.text,
                g: _firstPartyGController.text,
                idNumber: _firstPartyIdNumberController.text,
                signatureUrl: '',
              ),
            ),
            signatureFile: _firstPartySignatureFile,
          ));
    }
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: CustomStyle.redDark),
                  const SizedBox(width: 8),
                ],
                Text(title, style: CustomStyle.smallTextB),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).addBranch),
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
