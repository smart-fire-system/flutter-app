import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/profile/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/profile/bloc/state.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/widgets/cards.dart';

class ReportsAndContractsScreen extends StatelessWidget {
  const ReportsAndContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic _user;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(title: 'Reports & Contracts'),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileAuthenticated) {
            _user = state.user;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Large featured card - Users
                LargeCard(
                  icon: Icons.account_tree_rounded,
                  title: 'Reports',
                  subtitle: 'View and manage reports',
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                  ),
                  onTap: () =>
                      TabNavigator.reports.currentState?.pushNamed('/reports'),
                ),

                const SizedBox(height: 16),

                LargeCard(
                  icon: Icons.assignment,
                  title: 'Contracts',
                  subtitle: 'View and manage contracts',
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                  ),
                  onTap: () =>
                      TabNavigator.reports.currentState?.pushNamed('/reports/contracts'),
                ),

                const SizedBox(height: 16),

                // Grid of smaller cards
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_user is Employee) ...[
                        Expanded(
                          child: WideCard(
                            icon: Icons.assignment_add,
                            title: 'Create Contract',
                            subtitle: 'Create a new contract',
                            color: const Color(0xFFE11D48),
                            onTap: () => TabNavigator
                                .reports.currentState
                                ?.pushNamed('/reports/new-contract'),
                          ),
                        ),
                      ],
                      if (_user is Admin || _user is MasterAdmin) ...[
                      Expanded(
                        child: WideCard(
                          icon: Icons.edit,
                          title: 'Contract Components',
                          subtitle: 'Update contract components',
                          color: const Color(0xFFF43F5E),
                          onTap: () => TabNavigator
                              .reports.currentState
                              ?.pushNamed('/reports/contract-components'),
                        ),
                      ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
