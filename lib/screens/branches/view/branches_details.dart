import 'package:fire_alarm_system/models/admin.dart';
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

class BranchDetails extends StatefulWidget {
  final Admin admin;
  const BranchDetails({super.key, required this.admin});

  @override
  BranchDetailsState createState() => BranchDetailsState();
}

class BranchDetailsState extends State<BranchDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        return _buildDetails(context);
      },
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).branches),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${S.of(context).name}:',
                      style: CustomStyle.mediumTextB,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      widget.admin.name,
                      style: CustomStyle.mediumText,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${S.of(context).email}:',
                      style: CustomStyle.mediumTextB,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      widget.admin.email,
                      style: CustomStyle.mediumText,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${S.of(context).phone}:',
                      style: CustomStyle.mediumTextB,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      '${widget.admin.countryCode}    ${widget.admin.phoneNumber}',
                      style: CustomStyle.mediumText,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
              child: ElevatedButton(
                style: CustomStyle.normalButton,
                child: Text(S.of(context).changeAccessRole,
                    style: CustomStyle.normalButtonText),
                onPressed: () {
                  _changeRole();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeRole() async {
    String? selectedValue = S.of(context).admin;
    await Alert(
      context: context,
      title: S.of(context).changeAccessRole,
      type: AlertType.none,
      style: AlertStyle(
        titleStyle: CustomStyle.largeTextB,
        descStyle: CustomStyle.mediumText,
        animationType: AnimationType.grow,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile<String>(
                  title: Text(S.of(context).admin),
                  value: S.of(context).admin,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile<String>(
                  title: Text(S.of(context).regionalManager),
                  value: S.of(context).regionalManager,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile<String>(
                  title: Text(S.of(context).branchManager),
                  value: S.of(context).branchManager,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile<String>(
                  title: Text(S.of(context).employee),
                  value: S.of(context).employee,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile<String>(
                  title: Text(S.of(context).technican),
                  value: S.of(context).technican,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile<String>(
                  title: Text(S.of(context).client),
                  value: S.of(context).client,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile<String>(
                  title: Text(S.of(context).noRole),
                  value: S.of(context).noRole,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
      buttons: [
        DialogButton(
          child: Text(S.of(context).ok, style: CustomStyle.normalButtonText),
          onPressed: () async {
            UserRole newRole = UserRole.admin;
            if (selectedValue == S.of(context).regionalManager) {
              newRole = UserRole.regionalManager;
            } else if (selectedValue == S.of(context).branchManager) {
              newRole = UserRole.branchManager;
            } else if (selectedValue == S.of(context).employee) {
              newRole = UserRole.employee;
            } else if (selectedValue == S.of(context).technican) {
              newRole = UserRole.technican;
            } else if (selectedValue == S.of(context).client) {
              newRole = UserRole.client;
            } else if (selectedValue == S.of(context).noRole) {
              newRole = UserRole.noRole;
            } else {
              Navigator.pop(context);
              return;
            }
            Navigator.pop(context);
            await Alert(
              context: context,
              title: S.of(context).changeAccessRole,
              desc:
                  '${S.of(context).confirmChangeAccessRole}\n${S.of(context).name}: ${widget.admin.name}\n${S.of(context).role}: ${selectedValue!}',
              type: AlertType.warning,
              style: AlertStyle(
                titleStyle: CustomStyle.largeTextB,
                descStyle: CustomStyle.mediumText,
                animationType: AnimationType.grow,
              ),
              buttons: [
                DialogButton(
                  child: Text(S.of(context).ok,
                      style: CustomStyle.normalButtonText),
                  onPressed: () {
                    Navigator.pop(context);
                    /*
                    context.read<BranchesBloc>().add(ModifyRequested(
                        id: widget.admin.id,
                        oldRole: UserRole.admin,
                        newRole: newRole));
                    Navigator.pop(context);*/
                  },
                ),
                DialogButton(
                  child: Text(S.of(context).cancel,
                      style: CustomStyle.normalButtonText),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ).show();
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
