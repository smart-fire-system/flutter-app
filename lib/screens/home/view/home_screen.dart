import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/access_denied.dart';
import 'package:fire_alarm_system/widgets/side_menu.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/home/bloc/event.dart';
import 'package:fire_alarm_system/screens/home/bloc/state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _showSideMenu = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(AuthRequested());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSideMenu = (MediaQuery.of(context).size.width > 600);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeError) {
          context.read<HomeBloc>().add(AuthRequested());
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await CustomAlert.showError(context, state.error);
          });
        } else if (state is HomeNotAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.popAndPushNamed(context, '/welcome');
            context.read<HomeBloc>().add(ResetState());
          });
        } else if (state is HomeNotVerified) {
          _user = state.user;
          return CustomAccessDenied(
            user: _user!,
            onLogoutClick: () async {
              context.read<HomeBloc>().add(LogoutRequested());
            },
            onResendClick: () async {
              context.read<HomeBloc>().add(ResendEmailRequested());
            },
          );
        } else if (state is HomeNoRole) {
          _user = state.user;
          return CustomAccessDenied(
            user: _user!,
            onLogoutClick: () async {
              context.read<HomeBloc>().add(LogoutRequested());
            },
            onResendClick: () async {
              context.read<HomeBloc>().add(ResendEmailRequested());
            },
          );
        } else if (state is HomeAuthenticated) {
          _user = state.user;
          return _buildHome(context);
        }
        return const CustomLoading();
      },
    );
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).home,
          style: GoogleFonts.cairo(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
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
                    screen: ScreenType.home,
                    user: _user!,
                    width: 300,
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
                            Text(
                              S.of(context).app_name,
                              style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: Colors.blue[100],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const FaIcon(
                                          FontAwesomeIcons.magnifyingGlassChart,
                                          color: Colors.black),
                                      title: Text(
                                        S.of(context).system_monitoring_control,
                                        style: CustomStyle.smallTextB,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        S
                                            .of(context)
                                            .system_monitoring_description,
                                        style: CustomStyle.smallText,
                                      ),
                                    ),
                                    Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Perform some action
                                            },
                                            child: Text(
                                                S
                                                    .of(context)
                                                    .viewAndControlSystem,
                                                style: CustomStyle.smallText),
                                          ),
                                        ),
                                        if (_user?.role == UserRole.admin ||
                                            _user?.role == UserRole.technican)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Perform some action
                                              },
                                              child: Text(
                                                  S
                                                      .of(context)
                                                      .manageAndConfigureSystem,
                                                  style: CustomStyle.smallText),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: Colors.blue[100],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.summarize,
                                          color: Colors.black),
                                      title: Text(S.of(context).reports,
                                          style: CustomStyle.smallTextB),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        S.of(context).reportsDescription,
                                        style: CustomStyle.smallText,
                                      ),
                                    ),
                                    Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Perform some action
                                            },
                                            child: Text(S.of(context).visits,
                                                style: CustomStyle.smallText),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Perform some action
                                            },
                                            child: Text(
                                                S
                                                    .of(context)
                                                    .maintenanceContracts,
                                                style: CustomStyle.smallText),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Perform some action
                                            },
                                            child: Text(
                                                S
                                                    .of(context)
                                                    .systemStatusAndFaults,
                                                style: CustomStyle.smallText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: Colors.blue[100],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.feedback,
                                          color: Colors.black),
                                      title: Text(S.of(context).complaints,
                                          style: CustomStyle.smallTextB),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                          S.of(context).complaintsDescription,
                                          style: CustomStyle.smallText),
                                    ),
                                    Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Perform some action
                                            },
                                            child: Text(
                                                S.of(context).viewComplaints,
                                                style: CustomStyle.smallText),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Perform some action
                                            },
                                            child: Text(
                                                S.of(context).submitComplaint,
                                                style: CustomStyle.smallText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_user?.role == UserRole.admin ||
                                _user?.role == UserRole.regionalManager ||
                                _user?.role == UserRole.branchManager ||
                                _user?.role == UserRole.employee ||
                                _user?.role == UserRole.technican)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.blue[100],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.group,
                                            color: Colors.black),
                                        title: Text(S.of(context).users,
                                            style: CustomStyle.smallTextB),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                            S.of(context).usersDescription,
                                            style: CustomStyle.smallText),
                                      ),
                                      Wrap(
                                        children: [
                                          if (_user?.role == UserRole.admin)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Perform some action
                                                },
                                                child: Text(
                                                    S.of(context).admins,
                                                    style:
                                                        CustomStyle.smallText),
                                              ),
                                            ),
                                          if (_user?.role == UserRole.admin)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Perform some action
                                                },
                                                child: Text(
                                                    S
                                                        .of(context)
                                                        .regionalManagers,
                                                    style:
                                                        CustomStyle.smallText),
                                              ),
                                            ),
                                          if (_user?.role == UserRole.admin ||
                                              _user?.role ==
                                                  UserRole.regionalManager)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Perform some action
                                                },
                                                child: Text(
                                                    S
                                                        .of(context)
                                                        .branchManagers,
                                                    style:
                                                        CustomStyle.smallText),
                                              ),
                                            ),
                                          if (_user?.role == UserRole.admin ||
                                              _user?.role ==
                                                  UserRole.regionalManager ||
                                              _user?.role ==
                                                  UserRole.branchManager)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Perform some action
                                                },
                                                child: Text(
                                                    S.of(context).employees,
                                                    style:
                                                        CustomStyle.smallText),
                                              ),
                                            ),
                                          if (_user?.role == UserRole.admin ||
                                              _user?.role ==
                                                  UserRole.regionalManager ||
                                              _user?.role ==
                                                  UserRole.branchManager)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Perform some action
                                                },
                                                child: Text(
                                                    S.of(context).technicans,
                                                    style:
                                                        CustomStyle.smallText),
                                              ),
                                            ),
                                          if (_user?.role == UserRole.admin ||
                                              _user?.role ==
                                                  UserRole.regionalManager ||
                                              _user?.role ==
                                                  UserRole.branchManager ||
                                              _user?.role ==
                                                  UserRole.employee ||
                                              _user?.role == UserRole.technican)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Perform some action
                                                },
                                                child: Text(
                                                    S.of(context).clients,
                                                    style:
                                                        CustomStyle.smallText),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
}
