import 'package:fire_alarm_system/utils/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/widgets/side_menu.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/home/bloc/event.dart';
import 'package:fire_alarm_system/screens/home/bloc/state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _showSideMenu = (MediaQuery.of(context).size.width > 600);
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
            return _buildHome(context);
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

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context).home,
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
          context.read<HomeBloc>().add(RefreshRequested());
        },
        child: Row(
          children: [
            if (_showSideMenu || MediaQuery.of(context).size.width > 600)
              CustomSideMenu(
                highlightedItem: CustomSideMenuItem.home,
                user: _user!,
                width: MediaQuery.of(context).size.width > 600
                    ? 300
                    : MediaQuery.of(context).size.width,
                noActionItems: const [
                  CustomSideMenuItem.home,
                  CustomSideMenuItem.logout
                ],
                onItemClick: (item) async {
                  if (item == CustomSideMenuItem.logout) {
                    _showSideMenu = (MediaQuery.of(context).size.width > 600);
                    context.read<HomeBloc>().add(LogoutRequested());
                  }
                  if (item == CustomSideMenuItem.home) {
                    _showSideMenu = (MediaQuery.of(context).size.width > 600);
                    context.read<HomeBloc>().add(RefreshRequested());
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
                        padding: const EdgeInsets.only(top: 16),
                        child: Image.asset(
                          'assets/images/logo_poster.png',
                          fit: BoxFit.contain,
                          height: 100,
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
                                leading: const Icon(Icons.analytics,
                                    color: Colors.black),
                                title: Text(
                                  S.of(context).system_monitoring_control,
                                  style: CustomStyle.smallTextB,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  S.of(context).system_monitoring_description,
                                  style: CustomStyle.smallText,
                                ),
                              ),
                              Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Perform some action
                                      },
                                      child: Text(
                                          S.of(context).viewAndControlSystem,
                                          style: CustomStyle.smallText),
                                    ),
                                  ),
                                  if (_user!.role == UserRole.admin ||
                                      _user!.role == UserRole.technican)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
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
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
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
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Perform some action
                                      },
                                      child: Text(
                                          S.of(context).maintenanceContracts,
                                          style: CustomStyle.smallText),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Perform some action
                                      },
                                      child: Text(
                                          S.of(context).systemStatusAndFaults,
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
                                child: Text(S.of(context).complaintsDescription,
                                    style: CustomStyle.smallText),
                              ),
                              Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Perform some action
                                      },
                                      child: Text(S.of(context).viewComplaints,
                                          style: CustomStyle.smallText),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Perform some action
                                      },
                                      child: Text(S.of(context).submitComplaint,
                                          style: CustomStyle.smallText),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_user!.role == UserRole.admin ||
                          _user!.role == UserRole.regionalManager ||
                          _user!.role == UserRole.branchManager ||
                          _user!.role == UserRole.employee ||
                          _user!.role == UserRole.technican)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.blue[100],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.group,
                                      color: Colors.black),
                                  title: Text(S.of(context).users,
                                      style: CustomStyle.smallTextB),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(S.of(context).usersDescription,
                                      style: CustomStyle.smallText),
                                ),
                                Wrap(
                                  children: [
                                    if (_user!.role == UserRole.admin)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/admins');
                                          },
                                          child: Text(S.of(context).admins,
                                              style: CustomStyle.smallText),
                                        ),
                                      ),
                                    if (_user!.role == UserRole.admin)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            // Perform some action
                                          },
                                          child: Text(
                                              S.of(context).regionalManagers,
                                              style: CustomStyle.smallText),
                                        ),
                                      ),
                                    if (_user!.role == UserRole.admin ||
                                        _user!.role == UserRole.regionalManager)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            // Perform some action
                                          },
                                          child: Text(
                                              S.of(context).branchManagers,
                                              style: CustomStyle.smallText),
                                        ),
                                      ),
                                    if (_user!.role == UserRole.admin ||
                                        _user!.role ==
                                            UserRole.regionalManager ||
                                        _user!.role == UserRole.branchManager)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            // Perform some action
                                          },
                                          child: Text(S.of(context).employees,
                                              style: CustomStyle.smallText),
                                        ),
                                      ),
                                    if (_user!.role == UserRole.admin ||
                                        _user!.role ==
                                            UserRole.regionalManager ||
                                        _user!.role == UserRole.branchManager)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            // Perform some action
                                          },
                                          child: Text(S.of(context).technicans,
                                              style: CustomStyle.smallText),
                                        ),
                                      ),
                                    if (_user!.role == UserRole.admin ||
                                        _user!.role ==
                                            UserRole.regionalManager ||
                                        _user!.role == UserRole.branchManager ||
                                        _user!.role == UserRole.employee ||
                                        _user!.role == UserRole.technican)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            // Perform some action
                                          },
                                          child: Text(S.of(context).clients,
                                              style: CustomStyle.smallText),
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
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context).app_name,
          style: CustomStyle.appBarText,
        ),
        backgroundColor: CustomStyle.appBarColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.language,
              color: Colors.white,
            ),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(context);
            },
          ),
        ],
      ),
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
                        style: CustomStyle.normalButtonTextSmall,
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
      appBar: AppBar(
        title: Text(
          S.of(context).app_name,
          style: CustomStyle.appBarText,
        ),
        backgroundColor: CustomStyle.appBarColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
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
                    style: CustomStyle.normalButtonTextSmall,
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
