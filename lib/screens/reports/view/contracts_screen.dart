import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
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
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).contracts),
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
    _contracts = state.contracts!;
    if (_contracts.isEmpty) {
      return CustomEmpty(message: S.of(context).no_contracts_yet);
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
