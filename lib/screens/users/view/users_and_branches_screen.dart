import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/profile/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/profile/bloc/state.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/widgets/cards.dart';

class UsersAndBranchesScreen extends StatelessWidget {
  const UsersAndBranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: l10n.users_and_branches,
        leading: const Icon(Icons.people_alt_rounded),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          dynamic user;
          UserInfo userInfo = UserInfo();

          if (state is ProfileAuthenticated) {
            user = state.user;
            userInfo = user.info as UserInfo;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current User Card
                if (state is ProfileAuthenticated)
                  CurrentUserCard(
                    userInfo: userInfo,
                    role: user.permissions.role != null
                        ? UserInfo.getRoleName(context, user.permissions.role)
                        : l10n.noRole,
                  ),

                const SizedBox(height: 28),

                // Large featured card - Users
                LargeCard(
                  icon: Icons.account_tree_rounded,
                  title: l10n.users_branches_hierarchy_title,
                  subtitle: l10n.users_branches_hierarchy_subtitle,
                  titleColor: Colors.white,
                  subtitleColor: Colors.white,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [CustomStyle.redDark, CustomStyle.redDark],
                  ),
                  onTap: () => TabNavigator.usersAndBranches.currentState
                      ?.pushNamed('/users-diagram'),
                ),

                const SizedBox(height: 16),

                // Grid of smaller cards
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SmallCard(
                          icon: Icons.business_rounded,
                          title: l10n.branches,
                          subtitle: l10n.branches_subtitle,
                          color: const Color(0xFFE11D48),
                          onTap: () => TabNavigator
                              .usersAndBranches.currentState
                              ?.pushNamed('/branches'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SmallCard(
                          icon: Icons.apartment_rounded,
                          title: l10n.companies,
                          subtitle: l10n.companies_subtitle,
                          color: const Color(0xFFF43F5E),
                          onTap: () => TabNavigator
                              .usersAndBranches.currentState
                              ?.pushNamed('/companies'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Full width card - Branches
                WideCard(
                  icon: Icons.group_rounded,
                  title: l10n.users,
                  subtitle: l10n.users_subtitle,
                  color: const Color(0xFFEF4444),
                  onTap: () => TabNavigator.usersAndBranches.currentState
                      ?.pushNamed('/users'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
