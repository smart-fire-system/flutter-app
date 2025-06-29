import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/users/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/state.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/info.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class UserInfoScreen extends StatelessWidget {
  final String userId;
  const UserInfoScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'User Information'),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is! UsersAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }
          // Find the user by ID in all user lists
          final user = [
            ...state.masterAdmins,
            ...state.admins,
            ...state.companyManagers,
            ...state.branchManagers,
            ...state.employees,
            ...state.clients,
            ...state.noRoleUsers,
          ].cast<dynamic>().firstWhere(
                (u) => u.info.id == userId,
                orElse: () => null,
              );
          if (user == null) {
            return const Center(child: Text('User not found.'));
          }
          final info = user.info;
          final role = user is MasterAdmin
              ? 'Master Admin'
              : user is Admin
                  ? 'Admin'
                  : user is CompanyManager
                      ? 'Company Manager'
                      : user is BranchManager
                          ? 'Branch Manager'
                          : user is Employee
                              ? 'Employee'
                              : user is Client
                                  ? 'Client'
                                  : 'No Role';

          // Get company for all user types
          dynamic company;
          if (user is CompanyManager) {
            company = user.company;
          } else if (user is BranchManager ||
              user is Employee ||
              user is Client) {
            company = user.branch.company;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInfoCard(
                  title: 'User Information',
                  icon: Icons.person_outline,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        // If you have a user image URL, use it here
                        radius: 30,
                        child: Text(info.name.isNotEmpty ? info.name[0] : '?'),
                      ),
                      title: Text(info.name, style: CustomStyle.mediumTextB),
                      subtitle: Text(info.email, style: CustomStyle.smallText),
                    ),
                    CustomInfoItem(
                      title: 'Code',
                      value: info.code.toString(),
                    ),
                    CustomInfoItem(
                      title: 'Phone',
                      value: info.phoneNumber,
                    ),
                    CustomInfoItem(
                      title: 'Role',
                      value: role,
                    ),
                  ],
                ),
                if (company != null)
                  CustomInfoCard(
                    title: 'Company Information',
                    icon: Icons.business_outlined,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/company/details',
                        arguments: company.id,
                      );
                    },
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: Image.network(
                              company.logoURL,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.business),
                            ),
                          ),
                        ),
                        title:
                            Text(company.name, style: CustomStyle.smallTextB),
                        subtitle:
                            Text(company.comment, style: CustomStyle.smallText),
                      ),
                    ],
                  ),
                if (user is BranchManager || user is Employee || user is Client)
                  CustomInfoCard(
                    title: 'Branch Information',
                    icon: Icons.account_tree_outlined,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/branch/details',
                        arguments: user.branch.id,
                      );
                    },
                    children: [
                      CustomInfoItem(
                        title: 'Name',
                        value: user.branch.name,
                      ),
                      CustomInfoItem(
                        title: 'Code',
                        value: user.branch.code?.toString() ?? '',
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
