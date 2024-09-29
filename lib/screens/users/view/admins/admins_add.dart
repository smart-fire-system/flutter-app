import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminsBloc, AdminsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context).addNewAdmin,
              style: CustomStyle.appBarText,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: widget.users.asMap().entries.map((entry) {
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
            context
                .read<AdminsBloc>()
                .add(ModifyRequested(id: user.id, newRole: UserRole.admin));
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
