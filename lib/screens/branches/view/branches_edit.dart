import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/button.dart';
import 'package:fire_alarm_system/widgets/dropdown.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';

class EditBranchScreen extends StatefulWidget {
  final String branchId;
  const EditBranchScreen({
    super.key,
    required this.branchId,
  });

  @override
  EditBranchScreenState createState() => EditBranchScreenState();
}

class EditBranchScreenState extends State<EditBranchScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _commentController;
  bool _canDeleteBranches = false;
  bool _isFirstCall = true;
  Branch? _branch;
  List<Company> _companies = [];

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
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        AppLoading().dismiss(
          context: context,
          screen: AppScreen.editBranches,
        );
        if (state is BranchesAuthenticated && state.canEditBranches) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(
                context: context,
                title: Errors.getFirebaseErrorMessage(context, state.error!),
              );
              state.error = null;
            } else if (state.message != null &&
                BranchesMessage.branchModified == state.message) {
              state.message = null;
              CustomAlert.showSuccess(
                context: context,
                title: S.of(context).branchModified,
              ).then((_) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              });
            }
          });
          if (BranchesMessage.branchDeleted == state.message) {
            state.message = null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          } else {
            _canDeleteBranches = state.canDeleteBranches;
            _branch = state.branches
                .firstWhere((branch) => branch.id == widget.branchId);
            _companies = state.companies;
            if (_isFirstCall) {
              _isFirstCall = false;
              _nameController = TextEditingController(text: _branch!.name);
              _addressController =
                  TextEditingController(text: _branch!.address);
              _phoneController =
                  TextEditingController(text: _branch!.phoneNumber);
              _emailController = TextEditingController(text: _branch!.email);
              _commentController =
                  TextEditingController(text: _branch!.comment);
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
    AppLoading().dismiss(context: context, screen: AppScreen.editBranches);
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).editBranch),
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
                label: S.of(context).branchName,
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
              CustomDropdownSingle(
                title: S.of(context).company,
                subtitle: S.of(context).changeCompany,
                initialItem: CustomDropdownItem(
                  title: _branch!.company.name,
                  value: _branch!.company.id!,
                ),
                items: _companies.map((company) {
                  return CustomDropdownItem(
                    title: company.name,
                    value: company.id!,
                  );
                }).toList(),
                onChanged: (newCompany) {
                  _branch!.company = _companies
                      .firstWhere((company) => company.id == newCompany.value);
                },
              ),
              CustomTextField(
                label: S.of(context).comment,
                controller: _commentController,
                maxLines: 3,
              ),
              if (_canDeleteBranches)
                CustomNormalButton(
                  label: S.of(context).deleteBranch,
                  backgroundColor: CustomStyle.redDark,
                  fullWidth: true,
                  onPressed: () {
                    _deleteBranch(context);
                  },
                )
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
    }

    int? confirm = await CustomAlert.showConfirmation(
      context: context,
      title: S.of(context).editBranch,
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
        screen: AppScreen.editBranches,
        title: S.of(context).waitSavingBranch,
        type: 'edit',
      );
      context.read<BranchesBloc>().add(BranchModifyRequested(
            branch: Branch(
              id: _branch!.id,
              name: _nameController.text,
              address: _addressController.text,
              phoneNumber: _phoneController.text,
              email: _emailController.text,
              comment: _commentController.text,
              company: _branch!.company,
            ),
          ));
    }
  }

  void _deleteBranch(BuildContext context) async {
    int? confirm = await CustomAlert.showConfirmation(
      context: context,
      title: S.of(context).deleteBranch,
      subtitle: S.of(context).branchDeleteWarning,
      buttons: [
        CustomAlertConfirmationButton(
          title: S.of(context).yesDeleteBranch,
          value: 0,
          backgroundColor: CustomStyle.redDark,
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
        screen: AppScreen.editBranches,
        title: S.of(context).waitDeltingBranch,
        type: 'delete',
      );
      context.read<BranchesBloc>().add(
            BranchDeleteRequested(
              id: _branch!.id!,
            ),
          );
    }
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).editBranch),
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
