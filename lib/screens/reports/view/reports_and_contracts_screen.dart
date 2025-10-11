import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/widgets/cards.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class ReportsAndContractsScreen extends StatefulWidget {
  const ReportsAndContractsScreen({super.key});

  @override
  State<ReportsAndContractsScreen> createState() =>
      _ReportsAndContractsScreenState();
}

class _ReportsAndContractsScreenState extends State<ReportsAndContractsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: S.of(context).reports_contracts_title,
        leading: const Icon(Icons.article),
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
            title: S.of(context).reports_contracts_card_title,
            subtitle: S.of(context).reports_contracts_card_subtitle,
            titleColor: Colors.white,
            subtitleColor: Colors.white,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [CustomStyle.redDark, CustomStyle.redDark],
            ),
            onTap: () => TabNavigator.reports.currentState
                ?.pushNamed('/reports/contracts'),
          ),
          const SizedBox(height: 16),
          if (state.user is Admin || state.user is MasterAdmin) ...[
            WideCard(
              icon: Icons.edit,
              title: S.of(context).contract_components,
              subtitle: S.of(context).contract_components_subtitle,
              color: const Color(0xFFF43F5E),
              onTap: () => TabNavigator.reports.currentState
                  ?.pushNamed('/reports/contract-components'),
            ),
            const SizedBox(height: 16),
          ],
          WideCard(
            icon: Icons.assignment_add,
            title: S.of(context).new_visit_report,
            subtitle: S.of(context).new_visit_report_subtitle,
            color: const Color(0xFFF43F5E),
            onTap: () => TabNavigator.reports.currentState
                ?.pushNamed('/reports/new-visit-report'),
          ),
          const SizedBox(height: 16),
          WideCard(
            icon: Icons.assignment,
            title: S.of(context).visit_reports,
            subtitle: S.of(context).visit_reports_subtitle,
            color: const Color(0xFFF43F5E),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Feature not supported yet',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
