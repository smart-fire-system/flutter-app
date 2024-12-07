import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/screens/users/view/admins/admins_add.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
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
  bool _filterRequested = false;
  User? _user;
  List<Admin> _admins = [];
  List<Admin> _filteredAdmins = [];
  List<User> _users = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterAdmins);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSideMenu = (MediaQuery.of(context).size.width > 600);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAdmins() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filterRequested = true;
      _filteredAdmins = _admins
          .where((admin) =>
              admin.name.toLowerCase().contains(query) ||
              admin.email.toLowerCase() == query ||
              admin.phoneNumber.toLowerCase() == query)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminsBloc, AdminsState>(
      builder: (context, state) {
        if (state is AdminsAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (state.error != null) {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
              state.error = null;
            } else if (state.message != null) {
              if (state.message == AdminMessage.userModified) {
                CustomAlert.showSuccess(
                    context, S.of(context).accessRoleChangedSuccessMessage);
              state.message = null;
              }
            }
          });
          _user = state.user;
          _admins = state.admins;
          if (_filterRequested) {
            _filterRequested = false;
          } else {
            _filteredAdmins = state.admins;
            _searchController.removeListener(_filterAdmins);
            _searchController.clear();
            _searchController.addListener(_filterAdmins);
          }
          _users = state.users;
          return _buildAdmins(context);
        } else if (state is AdminsNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (Route<dynamic> route) => false,
            );
          });
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
        backgroundColor: CustomStyle.appBarColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(
            _showSideMenu ? Icons.keyboard_return : Icons.menu,
            color: _showSideMenu ? Colors.red : Colors.black,
          ),
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white)),
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
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AdminsBloc>().add(AuthChanged());
        },
        child: Row(
          children: [
            if (_showSideMenu || MediaQuery.of(context).size.width > 600)
              CustomSideMenu(
                highlightedItem: CustomSideMenuItem.admins,
                user: _user!,
                width: MediaQuery.of(context).size.width > 600
                    ? 300
                    : MediaQuery.of(context).size.width,
                noActionItems: const [
                  CustomSideMenuItem.admins,
                ],
                onItemClick: (item) async {
                  if (item == CustomSideMenuItem.admins) {
                    _showSideMenu = (MediaQuery.of(context).size.width > 600);
                    context.read<AdminsBloc>().add(AuthChanged());
                  }
                },
              ),
            if (!_showSideMenu || MediaQuery.of(context).size.width > 600)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddAdmin(users: _users),
                                ));
                          },
                          style: CustomStyle.normalButton,
                          child: Text(S.of(context).addNewAdmin,
                              style: CustomStyle.normalButtonText),
                        ),
                      ),
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
                      _buildUserTable(_admins, (admin) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminDetails(admin: admin),
                            ));
                      }),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTable(List<Admin> admins, Function(Admin) onRowTap) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: const TableBorder(
            horizontalInside: BorderSide(width: 0.5, color: Colors.grey)),
        columnWidths: const {
          0: FixedColumnWidth(50.0),
          1: FlexColumnWidth(5),
        },
        children: _filteredAdmins.asMap().entries.map((entry) {
          var admin = entry.value;

          return TableRow(
            children: [
              TableRowInkWell(
                onTap: () => onRowTap(admin),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text((entry.key + 1).toString()),
                ),
              ),
              TableRowInkWell(
                onTap: () => onRowTap(admin),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Text(
                        admin.name,
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
        }).toList(),
      ),
    );
  }
}
