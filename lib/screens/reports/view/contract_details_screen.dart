import 'package:fire_alarm_system/screens/reports/view/common.dart';
import 'package:fire_alarm_system/screens/reports/view/components_builder.dart';
import 'package:fire_alarm_system/screens/reports/view/export_pdf.dart';
import 'package:fire_alarm_system/screens/reports/view/signature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/reports/bloc/state.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/report.dart';

class ContractDetailsScreen extends StatefulWidget {
  final String contractId;

  const ContractDetailsScreen({
    super.key,
    required this.contractId,
  });

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  late ContractData _contract;
  late List<ContractItem> _contractItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Report'),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => ExportPdf().contract(
              context: context,
              items: _contractItems,
              contract: _contract,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<ReportsBloc, ReportsState>(
            builder: (context, state) {
              if (state is ReportsAuthenticated) {
                return _buildBody(state);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ReportsAuthenticated state) {
    if (state.contracts == null ||
        state.contractItems == null ||
        state.user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    _contractItems = state.contractItems!;
    _contract = state.contracts!.firstWhere(
      (c) => c.metaData.id == widget.contractId,
    );
    return ListView.separated(
      itemBuilder: (context, idx) {
        // Items range
        if (idx < _contractItems.length) {
          final item = _contractItems[idx];
          if (item.text != null) {
            final text =
                ContractsCommon().renderTemplate(_contract, item.text!);
            TextStyle style =
                const TextStyle(fontFamily: 'Arial', fontSize: 16);
            if (item.text!.bold == true) {
              style = style.copyWith(fontWeight: FontWeight.bold);
            }
            if (item.text!.underlined == true) {
              style = style.copyWith(decoration: TextDecoration.underline);
            }
            if (item.text!.color != null) {
              style = style.copyWith(color: item.text!.color);
            }
            return Container(
              color: item.text!.backgroundColor,
              width: double.infinity,
              child: Text(
                text,
                style: style,
                textAlign: item.text!.align,
              ),
            );
          }
          return const SizedBox.shrink();
        }
        if (idx == _contractItems.length) {
          return ComponentsBuilder(
            componentsData: _contract.componentsData,
            showOnly: true,
            onChange: (componentsData) {
              _contract.componentsData = componentsData;
            },
          );
        }
        // After items: show signatures section
        return SignatureHelper.buildSignaturesSection(context, _contract);
      },
      itemCount: () {
        return _contractItems.length + 2; // items + signatures
      }(),
      separatorBuilder: (context, idx) {
        // Add spacing between header blocks and items
        return const SizedBox(height: 16);
      },
    );
  }
}
