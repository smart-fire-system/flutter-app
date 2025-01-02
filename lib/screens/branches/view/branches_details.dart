import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/info.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BranchDetails extends StatefulWidget {
  final String branchId;
  const BranchDetails({super.key, required this.branchId});

  @override
  BranchDetailsState createState() => BranchDetailsState();
}

class BranchDetailsState extends State<BranchDetails> {
  Branch? _branch;
  bool _canEditBranches = false;
  bool _canViewCompanies = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        if (state is BranchesAuthenticated && state.canViewBranches) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
              state.error = null;
            } else if (state.message != null) {
              if (state.message == BranchesMessage.branchModified) {
                CustomAlert.showSuccess(context, S.of(context).branchModified);
                state.message = null;
              } else if (state.message == BranchesMessage.branchAdded) {
                CustomAlert.showSuccess(context, S.of(context).branchAdded);
                state.message = null;
              }
            }
          });
          _canEditBranches = state.canEditBranches;
          _canViewCompanies = state.canViewCompanies;
          _branch = state.branches
              .firstWhere((branch) => branch.id == widget.branchId);
          return _buildDetails(context);
        } else if (state is BranchesNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushNamed(context, '/signIn');
          });
        }
        return const CustomLoading();
      },
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _branch!.name),
      floatingActionButton: !_canEditBranches
          ? null
          : FloatingActionButton.extended(
              backgroundColor: CustomStyle.redDark,
              onPressed: () async {
                TabNavigator.settings.currentState
                    ?.pushNamed('/branches/edit', arguments: widget.branchId);
              },
              icon: const Icon(
                Icons.edit,
                size: 30,
                color: Colors.white,
              ),
              label: Text("Edit", style: CustomStyle.mediumTextWhite),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInfoCard(
                title: "Branch Information",
                icon: Icons.info_outline,
                children: [
                  CustomInfoItem(
                    title: "Name",
                    value: _branch!.name,
                  ),
                  CustomInfoItem(
                    title: "Code",
                    value: _branch!.code.toString(),
                  ),
                  CustomInfoItem(
                    title: "Created At",
                    value: _branch!.createdAt.toDate().toString(),
                  ),
                ],
              ),
              CustomInfoCard(
                title: "Company Information",
                icon: Icons.business_outlined,
                onTap: !_canViewCompanies
                    ? null
                    : () {
                        TabNavigator.settings.currentState?.pushNamed(
                            '/companies/details',
                            arguments: _branch!.company.id);
                      },
                children: [
                  ListTile(
                    title: Text(_branch!.company.name,
                        style: CustomStyle.smallTextB),
                    subtitle: Text(_branch!.company.comment,
                        style: CustomStyle.smallText),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_branch!.company.logoURL),
                      radius: 25.0,
                    ),
                  ),
                ],
              ),
              CustomInfoCard(
                title: "Contact Information",
                icon: Icons.contact_phone_outlined,
                children: [
                  CustomInfoItem(
                    title: "Phone",
                    value: _branch!.phoneNumber,
                  ),
                  CustomInfoItem(
                    title: "Email",
                    value: _branch!.email,
                  ),
                ],
              ),
              CustomInfoCard(
                title: "Address",
                icon: Icons.location_on_outlined,
                children: [
                  CustomInfoItem(
                    value: _branch!.address,
                  ),
                ],
              ),
              if (_branch!.comment.isNotEmpty)
                CustomInfoCard(
                  title: "Comment",
                  icon: Icons.comment_outlined,
                  children: [
                    CustomInfoItem(
                      value: _branch!.comment,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
