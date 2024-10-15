import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/screens/users/view/admins/admins_add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/user_auth.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/side_menu.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/users/bloc/admins/bloc.dart';
import 'package:fire_alarm_system/screens/users/bloc/admins/event.dart';
import 'package:fire_alarm_system/screens/users/bloc/admins/state.dart';

import 'admins_details.dart';

class AdminsScreen extends StatefulWidget {
  const AdminsScreen({super.key});

  @override
  AdminsScreenState createState() => AdminsScreenState();
}

class AdminsScreenState extends State<AdminsScreen> {
  bool _showSideMenu = false;
  UserAuth? _userAuth;
  List<Admin> _admins = [];

  @override
  void initState() {
    super.initState();
    context.read<AdminsBloc>().add(AuthRequested());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSideMenu = (MediaQuery.of(context).size.width > 600);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminsBloc, AdminsState>(
      builder: (context, state) {
        if (state is AdminModifed) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            context.read<AdminsBloc>().add(AuthRequested());
            if (state.error != null) {
              await CustomAlert.showError(context, state.error!);
            } else {
              await CustomAlert.showSuccess(
                  context, S.of(context).accessRoleChangedSuccessMessage);
            }
          });
        } else if (state is AdminDeleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            context.read<AdminsBloc>().add(AuthRequested());
            if (state.error != null) {
              await CustomAlert.showError(context, state.error!);
            } else {
              await CustomAlert.showSuccess(
                  context, S.of(context).userDeletedSuccessMessage);
            }
          });
        } else if (state is NoRoleListLoaded) {
          context.read<AdminsBloc>().add(AuthRequested());
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAdmin(users: state.users),
                ));
          });
        } else if (state is AdminsError) {
          context.read<AdminsBloc>().add(AuthRequested());
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await CustomAlert.showError(context, state.error);
          });
        } else if (state is AdminsNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (Route<dynamic> route) => false,
            );
            context.read<AdminsBloc>().add(ResetState());
          });
        } else if (state is AdminsNotAuthorized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.popAndPushNamed(context, '/home');
            context.read<AdminsBloc>().add(ResetState());
          });
        } else if (state is AdminsAuthenticated) {
          _userAuth = state.user;
          _admins = state.admins;
          return _buildAdmins(context);
        }
        return const CustomLoading();
      },
    );
  }

  Widget _buildAdmins(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).admins,
          style: CustomStyle.appBarText,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: _showSideMenu ? Colors.white : Colors.black,
          ),
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  _showSideMenu ? Colors.blueAccent : Colors.white)),
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _showSideMenu = !_showSideMenu;
              });
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Action for notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _showSideMenu
                ? CustomSideMenu(
                    highlightedItem: CustomSideMenuItem.admins,
                    user: _userAuth!.user!,
                  )
                : Container(),
            SizedBox(
              width: _showSideMenu
                  ? MediaQuery.of(context).size.width < 600
                      ? 300
                      : MediaQuery.of(context).size.width - 300
                  : MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (MediaQuery.of(context).size.width < 600 &&
                            _showSideMenu) {
                          setState(() {
                            _showSideMenu = false;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<AdminsBloc>()
                                    .add(NoRoleListRequested());
                              },
                              style: CustomStyle.normalButton,
                              child: Text(S.of(context).addNewAdmin,
                                  style: CustomStyle.normalButtonText),
                            ),
                            _buildUserTable(_admins, (index) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminDetails(admin: _admins[index - 1]),
                                  ));
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTable(List<Admin> admins, Function(int) onRowTap) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: const TableBorder(
            horizontalInside: BorderSide(width: 0.5, color: Colors.grey)),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(5),
        },
        children: [
          ...admins.map((user) {
            return TableRow(
              decoration: BoxDecoration(
                color: (user.index % 2 == 0)
                    ? Colors.transparent
                    : Colors.transparent,
              ),
              children: [
                TableRowInkWell(
                  onTap: () => onRowTap(user.index),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(user.index.toString()),
                  ),
                ),
                TableRowInkWell(
                  onTap: () => onRowTap(user.index),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Text(
                          user.name,
                          style: CustomStyle.smallText,
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
