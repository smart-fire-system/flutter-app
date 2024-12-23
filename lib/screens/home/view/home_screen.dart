import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/bottom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/home/bloc/event.dart';
import 'package:fire_alarm_system/screens/home/bloc/state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final CustomBottomNavigatorItems currentTab;

  const HomeScreen({
    this.currentTab = CustomBottomNavigatorItems.system,
    super.key,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  User? _user;
  CustomBottomNavigatorItems selectedTab = CustomBottomNavigatorItems.system;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.currentTab;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(CustomBottomNavigatorItems item) {
    setState(() {
      selectedTab = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeNotAuthenticated) {
          if (state.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
            });
          } else if (state.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              CustomAlert.showSuccess(context, state.message!);
            });
          }
          return _buildWelcome(context);
        } else if (state is HomeAuthenticated) {
          _user = state.user;
          if (state.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              CustomAlert.showError(context,
                  Errors.getFirebaseErrorMessage(context, state.error!));
            });
          } else if (state.message != null && state.message == 'Email Sent') {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              CustomAlert.showSuccess(context, S.of(context).reset_email_sent);
            });
          }
          if (state.isEmailVerified &&
              state.isPhoneAdded &&
              state.hasUserRole) {
            if (selectedTab == CustomBottomNavigatorItems.reports) {
              return _buildReportsTab(context);
            } else if (selectedTab == CustomBottomNavigatorItems.complaints) {
              return _buildComplaintsTab(context);
            } else if (selectedTab == CustomBottomNavigatorItems.users) {
              return _buildUsersTab(context);
            } else if (selectedTab == CustomBottomNavigatorItems.system) {
              return _buildSystemTab(context);
            } else if (selectedTab == CustomBottomNavigatorItems.profile) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                Navigator.pushReplacementNamed(context, '/profile');
              });
            }
          } else {
            return _buildNotAuthorized(
                context: context,
                isEmailVerified: state.isEmailVerified,
                isPhoneAdded: state.isPhoneAdded,
                hasUserRole: state.hasUserRole);
          }
        }
        return const CustomLoading();
      },
    );
  }

  Widget _buildUsersTab(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: _user!.role == UserRole.admin
              ? '${S.of(context).users} ${S.of(context).and} ${S.of(context).branches}'
              : S.of(context).users),
      bottomNavigationBar: CustomBottomNavigator(
        user: _user!,
        selectedItem: CustomBottomNavigatorItems.users,
        onItemClick: (CustomBottomNavigatorItems item) {
          setState(() {
            selectedTab = item;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            if (_user!.role == UserRole.admin)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/logo/2.jpg',
                  ),
                  title: Text(
                    S.of(context).branches,
                    style: CustomStyle.largeTextB,
                  ),
                  subtitle: Text(
                    S.of(context).branchesDescription,
                    style: CustomStyle.smallText,
                  ),
                ),
              ),
            if (_user!.role == UserRole.admin)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).branches,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: const Icon(
                    Icons.looks_one,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
            if (_user!.role == UserRole.admin)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).buildings,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: const Icon(
                    Icons.looks_two,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/logo/2.jpg',
                ),
                title: Text(
                  S.of(context).users,
                  style: CustomStyle.largeTextB,
                ),
                subtitle: Text(
                  S.of(context).usersDescription,
                  style: CustomStyle.smallText,
                ),
              ),
            ),
            if (_user!.role == UserRole.admin)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).admins,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: const Icon(
                    Icons.looks_one,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
            if (_user!.role == UserRole.admin)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).regionalManagers,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: const Icon(
                    Icons.looks_two,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
            if (_user!.role == UserRole.admin ||
                _user!.role == UserRole.regionalManager)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).branchManagers,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: Icon(
                    _user!.role == UserRole.admin
                        ? Icons.looks_3
                        : Icons.looks_one,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
            if (_user!.role == UserRole.admin ||
                _user!.role == UserRole.regionalManager ||
                _user!.role == UserRole.branchManager)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).employees,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: Icon(
                    _user!.role == UserRole.admin
                        ? Icons.looks_6
                        : _user!.role == UserRole.regionalManager
                            ? Icons.looks_two
                            : Icons.looks_one,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
            if (_user!.role == UserRole.admin ||
                _user!.role == UserRole.regionalManager ||
                _user!.role == UserRole.branchManager)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).technicans,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: Icon(
                    _user!.role == UserRole.admin
                        ? Icons.looks_5
                        : _user!.role == UserRole.regionalManager
                            ? Icons.looks_3
                            : Icons.looks_two,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
            if (_user!.role == UserRole.admin ||
                _user!.role == UserRole.regionalManager ||
                _user!.role == UserRole.branchManager ||
                _user!.role == UserRole.employee ||
                _user!.role == UserRole.technican)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).clients,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: Icon(
                    _user!.role == UserRole.admin
                        ? Icons.looks_6
                        : _user!.role == UserRole.regionalManager
                            ? Icons.looks_4
                            : _user!.role == UserRole.branchManager
                                ? Icons.looks_3
                                : Icons.looks_one,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintsTab(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).complaints),
      bottomNavigationBar: CustomBottomNavigator(
        user: _user!,
        selectedItem: CustomBottomNavigatorItems.complaints,
        onItemClick: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/logo/2.jpg',
                ),
                title: Text(
                  S.of(context).complaints,
                  style: CustomStyle.largeTextB,
                ),
                subtitle: Text(
                  S.of(context).complaintsDescription,
                  style: CustomStyle.smallText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  S.of(context).viewComplaints,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.list,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  S.of(context).submitComplaint,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.support_agent,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).reports),
      bottomNavigationBar: CustomBottomNavigator(
        user: _user!,
        selectedItem: CustomBottomNavigatorItems.reports,
        onItemClick: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/logo/2.jpg',
                ),
                title: Text(
                  S.of(context).reports,
                  style: CustomStyle.largeTextB,
                ),
                subtitle: Text(
                  S.of(context).reportsDescription,
                  style: CustomStyle.smallText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  S.of(context).visits,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.article,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  S.of(context).maintenanceContracts,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.article,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  S.of(context).systemStatusAndFaults,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.article,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemTab(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).system),
      bottomNavigationBar: CustomBottomNavigator(
        user: _user!,
        selectedItem: CustomBottomNavigatorItems.system,
        onItemClick: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/logo/2.jpg',
                ),
                title: Text(
                  S.of(context).system_monitoring_control,
                  style: CustomStyle.largeTextB,
                ),
                subtitle: Text(
                  S.of(context).system_monitoring_description,
                  style: CustomStyle.smallText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  S.of(context).viewAndControlSystem,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(
                  Icons.bar_chart_outlined,
                  color: CustomStyle.redDark,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CustomStyle.redDark,
                ),
                onTap: () {
                  print("==========================");
                  Navigator.pushNamed(context, '/branches');
                },
              ),
            ),
            if (_user!.role == UserRole.admin ||
                _user!.role == UserRole.technican)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    S.of(context).manageAndConfigureSystem,
                    style: CustomStyle.largeTextB,
                  ),
                  leading: const Icon(
                    Icons.settings,
                    color: CustomStyle.redDark,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: CustomStyle.redDark,
                  ),
                  onTap: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).app_name),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 50.0),
                    child: Image.asset(
                      'assets/images/logo/2.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signIn',
                            arguments: {'login': true});
                      },
                      style: CustomStyle.normalButton,
                      child: Text(
                        S.of(context).login,
                        style: CustomStyle.normalButtonText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signIn',
                            arguments: {'signup': true});
                      },
                      style: CustomStyle.normalButton,
                      child: Text(
                        S.of(context).signup,
                        style: CustomStyle.normalButtonText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 30.0, bottom: 30.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            S.of(context).or,
                            style: CustomStyle.smallText,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<HomeBloc>().add(GoogleLoginRequested());
                      },
                      icon: const Icon(FontAwesomeIcons.google,
                          color: Colors.white),
                      label: Text(
                        S.of(context).continue_with_google,
                        style: CustomStyle.normalButtonTextSmallWhite,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotAuthorized(
      {required BuildContext context,
      required bool isEmailVerified,
      required bool isPhoneAdded,
      required bool hasUserRole}) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).app_name),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(RefreshRequested());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  S.of(context).stepsToComplete,
                  style: CustomStyle.largeTextB,
                ),
                leading: const Icon(Icons.refresh, size: 40),
                onTap: () {
                  context.read<HomeBloc>().add(RefreshRequested());
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                child: ListTile(
                  title: Text(
                    _user!.name,
                    style: CustomStyle.largeTextB,
                  ),
                  subtitle: Text(_user!.email, style: CustomStyle.mediumText),
                  leading: const Icon(Icons.person, size: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: isEmailVerified
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 30,
                          ),
                    title: Text(
                      S.of(context).emailVerificationTitle,
                      style: CustomStyle.largeTextB,
                    ),
                    subtitle: Text(
                      isEmailVerified
                          ? S.of(context).emailVerified
                          : S.of(context).emailNotVerified,
                      style: CustomStyle.mediumText,
                    ),
                    onTap: isEmailVerified
                        ? null
                        : () {
                            context
                                .read<HomeBloc>()
                                .add(ResendEmailRequested());
                          },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: isPhoneAdded
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 30,
                          ),
                    title: Text(
                      S.of(context).phoneNumberTitle,
                      style: CustomStyle.largeTextB,
                    ),
                    subtitle: Text(
                      isPhoneAdded
                          ? S.of(context).phoneNumberAdded
                          : S.of(context).phoneNumberNotAdded,
                      style: CustomStyle.mediumText,
                    ),
                    onTap: isPhoneAdded
                        ? null
                        : () {
                            Navigator.pushNamed(context, '/profile');
                          },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: ListTile(
                    leading: hasUserRole
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 30,
                          ),
                    title: Text(
                      S.of(context).accessRoleTitle,
                      style: CustomStyle.largeTextB,
                    ),
                    subtitle: Text(
                      hasUserRole
                          ? '${S.of(context).roleAssigned} [${User.getRoleName(context, _user!.role)}]'
                          : S.of(context).roleNotAssigned,
                      style: CustomStyle.mediumText,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<HomeBloc>().add(LogoutRequested());
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    S.of(context).logout,
                    style: CustomStyle.normalButtonTextSmallWhite,
                  ),
                  style: CustomStyle.normalButtonRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
