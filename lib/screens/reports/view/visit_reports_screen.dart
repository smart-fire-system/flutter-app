import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/screens/reports/view/helper/visit_report_summary.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import 'view.dart';

class VisitReportsScreen extends StatefulWidget {
  final String contractId;
  const VisitReportsScreen({super.key, required this.contractId});

  @override
  State<VisitReportsScreen> createState() => _VisitReportsScreenState();
}

class _VisitReportsScreenState extends State<VisitReportsScreen> {
  List<VisitReportData> _visitReports = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).visit_reports),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(S.of(context).new_visit_report,
            style: CustomStyle.mediumTextWhite),
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    NewVisitReportScreen(contractId: widget.contractId)),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: BlocBuilder<ReportsBloc, ReportsState>(
        builder: (context, state) {
          if (state is ReportsAuthenticated) {
            return _buildBody(state);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildBody(ReportsAuthenticated state) {
    if (state.contracts == null || state.contractItems == null) {
      return const Center(child: CircularProgressIndicator());
    }
    print(widget.contractId);
    print(state.visitReports);
    _visitReports = state.visitReports!
        .where((v) => v.contractId == widget.contractId)
        .toList();
    if (_visitReports.isEmpty) {
      return CustomEmpty(message: S.of(context).no_contracts_yet);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _visitReports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        return VisitReportSummary(
          visitReport: _visitReports[i],
          index: i,
          onTap: () {},
        );
      },
    );
  }
}
