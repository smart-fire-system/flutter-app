import 'package:fire_alarm_system/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: l10n.reports_contracts_title,
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
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LargeCard(
            icon: Icons.assignment,
            title: l10n.reports_contracts_card_title,
            subtitle: l10n.reports_contracts_card_subtitle,
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
              title: l10n.contract_components,
              subtitle: l10n.contract_components_subtitle,
              color: const Color(0xFFF43F5E),
              onTap: () => TabNavigator.reports.currentState
                  ?.pushNamed('/reports/contract-components'),
            ),
            const SizedBox(height: 16),
          ],
          WideCard(
            icon: Icons.assignment_add,
            title: l10n.new_visit_report,
            subtitle: l10n.new_visit_report_subtitle,
            color: const Color(0xFFF43F5E),
            onTap: () => TabNavigator.reports.currentState
                ?.pushNamed('/reports/new-visit-report'),
          ),
          const SizedBox(height: 16),
          WideCard(
            icon: Icons.assignment,
            title: l10n.visit_reports,
            subtitle: l10n.visit_reports_subtitle,
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
