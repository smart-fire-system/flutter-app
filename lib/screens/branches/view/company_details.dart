import 'package:card_loading/card_loading.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/info.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final String companyId;
  const CompanyDetailsScreen({super.key, required this.companyId});

  @override
  CompanyDetailsScreenState createState() => CompanyDetailsScreenState();
}

class CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  Company? _company;
  List<Branch> _branches = [];
  bool _canEditCompanies = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        if (state is BranchesAuthenticated && state.canViewCompanies) {
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
            _company = state.companies
                .firstWhere((company) => company.id == widget.companyId);
            _branches = List.from(
              state.branches
                  .where((branch) => branch.company.id == _company!.id),
            );
            _canEditCompanies = state.canEditCompanies;
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
    return Scaffold(
      appBar: CustomAppBar(title: _company!.name),
      floatingActionButton: !_canEditCompanies
          ? null
          : FloatingActionButton.extended(
              backgroundColor: CustomStyle.redDark,
              onPressed: () async {
                TabNavigator.settings.currentState
                    ?.pushNamed('/company/edit', arguments: widget.companyId);
              },
              icon: const Icon(
                Icons.edit,
                size: 30,
                color: Colors.white,
              ),
              label: Text(S.of(context).edit_information,
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
                title: S.of(context).companyLogo,
                icon: Icons.image,
                children: [
                  Center(
                      child: Image.network(
                    _company!.logoURL,
                    width: 200,
                  )),
                ],
              ),
              CustomInfoCard(
                title: S.of(context).companyInformation,
                icon: Icons.info_outline,
                children: [
                  CustomInfoItem(
                    title: S.of(context).name,
                    value: _company!.name,
                  ),
                  CustomInfoItem(
                    title: S.of(context).code,
                    value: _company!.code.toString(),
                  ),
                  CustomInfoItem(
                    title: S.of(context).createdAt,
                    value: _company!.createdAt!.toDate().toString(),
                  ),
                ],
              ),
              CustomInfoCard(
                title: S.of(context).contactInformation,
                icon: Icons.contact_phone_outlined,
                children: [
                  CustomInfoItem(
                    title: S.of(context).phone,
                    value: _company!.phoneNumber,
                  ),
                  CustomInfoItem(
                    title: S.of(context).email,
                    value: _company!.email,
                  ),
                ],
              ),
              CustomInfoCard(
                title: S.of(context).address,
                icon: Icons.location_on_outlined,
                children: [
                  CustomInfoItem(
                    value: _company!.address,
                  ),
                ],
              ),
              if (_company!.comment.isNotEmpty)
                CustomInfoCard(
                  title: S.of(context).comment,
                  icon: Icons.comment_outlined,
                  children: [
                    CustomInfoItem(
                      value: _company!.comment,
                    ),
                  ],
                ),
              if (_branches.isNotEmpty)
                CustomInfoCard(
                  title: S.of(context).branches,
                  icon: Icons.business_outlined,
                  children: [
                    ...List.generate(_branches.length, (index) {
                      return ListTile(
                        leading: Text(
                          (index + 1).toString(),
                          style: CustomStyle.mediumTextBRed,
                        ),
                        title: Text(
                          _branches[index].name,
                          style: CustomStyle.mediumTextB,
                        ),
                        subtitle: _branches[index].comment.isEmpty
                            ? null
                            : Text(
                                _branches[index].comment,
                                style: CustomStyle.smallText,
                              ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          TabNavigator.settings.currentState?.pushNamed(
                              '/branch/details',
                              arguments: _branches[index].id);
                        },
                      );
                    }),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).companyInformation),
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
