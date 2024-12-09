import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/users/bloc/admins/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/admins/event.dart';
import 'package:fire_alarm_system/screens/users/bloc/admins/state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddAdmin extends StatefulWidget {
  final List<User> users;

  const AddAdmin({required this.users, super.key});

  @override
  AddAdminState createState() => AddAdminState();
}

class AddAdminState extends State<AddAdmin> {
  String? selectedValue;
  final TextEditingController _searchController = TextEditingController();
  List<User> _filteredUsers = [];
  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.users;
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
      _filteredUsers = widget.users
          .where((user) =>
              user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase() == query ||
              user.phoneNumber.toLowerCase() == query)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminsBloc, AdminsState>(
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
                            _addAdmin(user);
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

  Future<void> _addAdmin(User user) async {
    await Alert(
      context: context,
      title: S.of(context).changeAccessRole,
      desc:
          '${S.of(context).confirmChangeAccessRole}\n${S.of(context).name}: ${user.name}\n${S.of(context).email}: ${user.email}\n${S.of(context).role}: ${S.of(context).admin}',
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
            context.read<AdminsBloc>().add(ModifyRequested(
                id: user.id, oldRole: user.role, newRole: UserRole.admin));
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
  }
}
