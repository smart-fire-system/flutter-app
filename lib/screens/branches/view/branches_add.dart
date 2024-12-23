import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddBranch extends StatefulWidget {
  final List<Branch> branches;

  const AddBranch({required this.branches, super.key});

  @override
  AddBranchestate createState() => AddBranchestate();
}

class AddBranchestate extends State<AddBranch> {
  String? selectedValue;
  final TextEditingController _searchController = TextEditingController();
  List<Branch> _filteredUsers = [];
  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.branches;
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = widget.branches
          .where((user) =>
              user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase() == query ||
              user.phoneNumber.toLowerCase() == query)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: S.of(context).addNewAdmin),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: S.of(context).searchBy,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _filteredUsers.asMap().entries.map((entry) {
                    var user = entry.value;
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          leading: const Icon(Icons.add),
                          onTap: () {
                            _addBranch(user);
                          },
                        ));
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addBranch(Branch branch) async {
    /*
    await Alert(
      context: context,
      title: S.of(context).changeAccessRole,
      desc:
          '${S.of(context).confirmChangeAccessRole}\n${S.of(context).name}: ${branch.name}\n${S.of(context).email}: ${branch.email}\n${S.of(context).role}: ${S.of(context).admin}',
      type: AlertType.warning,
      style: AlertStyle(
        titleStyle: CustomStyle.largeTextB,
        descStyle: CustomStyle.mediumText,
        animationType: AnimationType.grow,
      ),
      buttons: [
        DialogButton(
          child: Text(S.of(context).ok, style: CustomStyle.normalButtonText),
          onPressed: () {
            Navigator.pop(context);
            context.read<BranchesBloc>().add(ModifyRequested(
                id: branch.id, oldRole: branch.role, newRole: UserRole.admin));
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child:
              Text(S.of(context).cancel, style: CustomStyle.normalButtonText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
    */
  }
  
}
