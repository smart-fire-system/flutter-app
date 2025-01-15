import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
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
import 'package:rflutter_alert/rflutter_alert.dart';

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
              );
            }
          });
          if (BranchesMessage.branchDeleted == state.message) {
            state.message = null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              TabNavigator.settings.currentState?.pop();
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
        return const CustomLoading();
      },
    );
  }

  Widget _buildEditor(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _branch!.name),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Save Changes", style: CustomStyle.mediumTextWhite),
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.save,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () async {
          await CustomAlert.showSuccess(
              context: context, title: "Hello", subtitle: "World");
          print("Done");
          return;
          context.read<BranchesBloc>().add(BranchModifyRequested(
                branch: Branch(
                  code: _branch!.code,
                  id: _branch!.id,
                  name: _nameController.text,
                  address: _addressController.text,
                  phoneNumber: _phoneController.text,
                  email: _emailController.text,
                  comment: _commentController.text,
                  createdAt: _branch!.createdAt,
                  company: _branch!.company,
                ),
              ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                label: 'Branch Name',
                controller: _nameController,
              ),
              CustomTextField(
                label: 'Address',
                controller: _addressController,
              ),
              CustomTextField(
                label: 'Phone Number',
                controller: _phoneController,
                inputType: TextInputType.phone,
              ),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                inputType: TextInputType.emailAddress,
              ),
              CustomDropdownSingle(
                title: 'Company',
                subtitle: 'Change Company',
                initialItem: CustomDropdownItem(
                  title: _branch!.company.name,
                  value: _branch!.company.id,
                ),
                items: _companies.map((company) {
                  return CustomDropdownItem(
                    title: company.name,
                    value: company.id,
                  );
                }).toList(),
                onChanged: (newCompany) {},
              ),
              CustomTextField(
                label: 'Comment',
                controller: _commentController,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
