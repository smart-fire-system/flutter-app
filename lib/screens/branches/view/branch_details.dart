import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/date.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/info.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';

class BranchDetailsScreen extends StatefulWidget {
  final String branchId;
  const BranchDetailsScreen({super.key, required this.branchId});

  @override
  BranchDetailsScreenState createState() => BranchDetailsScreenState();
}

class BranchDetailsScreenState extends State<BranchDetailsScreen> {
  Branch? _branch;
  AppPermissions _permissions = AppPermissions();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        if (state is BranchesAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(
                context: context,
                title: Errors.getFirebaseErrorMessage(context, state.error!),
              );
              state.error = null;
            }
          });
          try {
            if (state.user is MasterAdmin || state.user is Admin) {
              _branch = state.branches
                  .firstWhere((branch) => branch.id == widget.branchId);
            } else if (state.user is CompanyManager) {
              _branch = state.user.branches
                  .firstWhere((branch) => branch.id == widget.branchId);
            } else {
              _branch = state.user.branch;
            }
            _permissions = state.user.permissions;
            return _buildDetails(context);
          } catch (e) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
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

  Widget _buildDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: _branch!.name),
      floatingActionButton: !_permissions.canEditBranches
          ? null
          : FloatingActionButton.extended(
              backgroundColor: CustomStyle.redDark,
              onPressed: () async {
                TabNavigator.usersAndBranches.currentState
                    ?.pushNamed('/branch/edit', arguments: widget.branchId);
              },
              icon: const Icon(
                Icons.edit,
                size: 30,
                color: Colors.white,
              ),
              label: Text(l10n.edit_information,
                  style: CustomStyle.mediumTextWhite),
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
                title: l10n.branchInformation,
                icon: Icons.info_outline,
                children: [
                  CustomInfoItem(
                    title: l10n.name,
                    value: _branch!.name,
                  ),
                  CustomInfoItem(
                    title: l10n.code,
                    value: _branch!.code.toString(),
                  ),
                  CustomInfoItem(
                    title: l10n.createdAt,
                    value: DateLocalizations.of(_branch!.createdAt, format: 'dd/MM/yyyy'),
                  ),
                ],
              ),
              CustomInfoCard(
                title: l10n.companyInformation,
                icon: Icons.business_outlined,
                onTap: () {
                  TabNavigator.usersAndBranches.currentState?.pushNamed(
                      '/company/details',
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
                title: l10n.contactInformation,
                icon: Icons.contact_phone_outlined,
                children: [
                  CustomInfoItem(
                    title: l10n.phone,
                    value: _branch!.phoneNumber,
                  ),
                  CustomInfoItem(
                    title: l10n.email,
                    value: _branch!.email,
                  ),
                ],
              ),
              CustomInfoCard(
                title: l10n.address,
                icon: Icons.location_on_outlined,
                children: [
                  CustomInfoItem(
                    value: _branch!.address,
                  ),
                ],
              ),
              if (_branch!.comment.isNotEmpty)
                CustomInfoCard(
                  title: l10n.comment,
                  icon: Icons.comment_outlined,
                  children: [
                    CustomInfoItem(
                      value: _branch!.comment,
                    ),
                  ],
                ),
              CustomInfoCard(
                title: l10n.firstPartyInformation,
                icon: Icons.person_outline,
                children: [
                  CustomInfoItem(
                    title: l10n.name,
                    value: _branch!.contractFirstParty.name,
                  ),
                  CustomInfoItem(
                    title: l10n.representativeName,
                    value: _branch!.contractFirstParty.repName,
                  ),
                  CustomInfoItem(
                    title: l10n.address,
                    value: _branch!.contractFirstParty.address,
                  ),
                  CustomInfoItem(
                    title: l10n.commercialRecord,
                    value: _branch!.contractFirstParty.commercialRecord,
                  ),
                  CustomInfoItem(
                    title: l10n.g,
                    value: _branch!.contractFirstParty.g,
                  ),
                  CustomInfoItem(
                    title: l10n.idNumber,
                    value: _branch!.contractFirstParty.idNumber,
                  ),
                  CustomInfoItem(
                    title: l10n.signature,
                    value: _branch!.contractFirstParty.signatureUrl == ""
                        ? l10n.noSignatureAddedYet
                        : '',
                  ),
                  if (_branch!.contractFirstParty.signatureUrl != "")
                    Image.network(
                      _branch!.contractFirstParty.signatureUrl,
                      width: 150,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: l10n.branchInformation),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Simulate loading for 5 items
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
