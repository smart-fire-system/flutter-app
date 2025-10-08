import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/widgets/cards.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(
        title: 'Reports & Contracts',
        leading: Icon(Icons.article),
      ),
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          if (state is ReportsAuthenticated) {
            return _buildBody(state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildBody(ReportsAuthenticated state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LargeCard(
            icon: Icons.assignment,
            title: 'Contracts',
            subtitle: 'View and manage contracts',
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CustomStyle.redDark, CustomStyle.redDark],
            ),
            onTap: () => TabNavigator.reports.currentState
                ?.pushNamed('/reports/contracts'),
          ),
          const SizedBox(height: 16),
          if (state.user is Employee) ...[
            WideCard(
              icon: Icons.assignment_add,
              title: 'Create Contract',
              subtitle: 'Create a new contract',
              color: const Color(0xFFE11D48),
              onTap: () => TabNavigator.reports.currentState
                  ?.pushNamed('/reports/new-contract'),
            ),
            const SizedBox(height: 16),
          ],
          if (state.user is Admin || state.user is MasterAdmin) ...[
            WideCard(
              icon: Icons.edit,
              title: 'Contract Components',
              subtitle: 'Update contract components',
              color: const Color(0xFFF43F5E),
              onTap: () => TabNavigator.reports.currentState
                  ?.pushNamed('/reports/contract-components'),
            ),
            const SizedBox(height: 16),
          ],
          LargeCard(
            icon: Icons.account_tree_rounded,
            title: 'Reports',
            subtitle: 'View and manage reports',
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CustomStyle.redDark, CustomStyle.redDark],
            ),
            onTap: () =>
                TabNavigator.reports.currentState?.pushNamed('/reports'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
