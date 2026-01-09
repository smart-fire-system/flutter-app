import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import 'helper/helper.dart';
import 'view.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  List<ContractData> _contracts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.contracts),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(l10n.new_contract,
            style: CustomStyle.mediumTextWhite),
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewContractScreen()),
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
    final l10n = AppLocalizations.of(context)!;
    if (state.contracts == null || state.contractItems == null) {
      return const Center(child: CircularProgressIndicator());
    }
    _contracts = state.contracts!;
    if (_contracts.isEmpty) {
      return CustomEmpty(message: l10n.no_contracts_yet);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _contracts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        return ContractSummary(
          contract: _contracts[i],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ViewContractScreen(contractId: _contracts[i].metaData.id!),
              ),
            );
          },
        );
      },
    );
  }
}
