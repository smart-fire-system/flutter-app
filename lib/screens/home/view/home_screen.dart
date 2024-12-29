import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/widgets/loading.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/alert.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/screens/home/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/home/bloc/event.dart';
import 'package:fire_alarm_system/screens/home/bloc/state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  User? _user;
  Screen _currentScreen = Screen.system;
  final List<Screen> _activeScreens = [Screen.system];
  bool _canPop = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setCurrentScreen(Screen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  Screen getCurrentScreen() {
    return _currentScreen;
  }

  void goBack() {
    setState(() {
      if (_activeScreens.length > 1) {
        _activeScreens.removeLast();
        _currentScreen = _activeScreens.last;
      } else {
        SystemNavigator.pop();
      }
    });
  }

  bool canPop() {
    return _canPop;
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
            //WidgetsBinding.instance.addPostFrameCallback((_) async {
            //  context.go('/system');
            //});
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
      body: IndexedStack(
        index: _currentScreen.index,
        children: const [
          TabNavigator(screen: Screen.system),
          TabNavigator(screen: Screen.reports),
          TabNavigator(screen: Screen.profile),
          TabNavigator(screen: Screen.complaints),
          TabNavigator(screen: Screen.settigns),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 205, 202, 202),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: CustomStyle.smallTextRed,
          unselectedLabelStyle: CustomStyle.smallTextGrey,
          backgroundColor: Colors.green,
          selectedItemColor: CustomStyle.redDark,
          unselectedItemColor: CustomStyle.greyMedium,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.shifting,
          currentIndex: _currentScreen.index,
          onTap: (int newIndex) {
            setState(() {
              _currentScreen = Screen.values[newIndex];
              _activeScreens.remove(_currentScreen);
              _activeScreens.add(_currentScreen);
              if (_activeScreens.length > 1) {
                _canPop = false;
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_outlined),
              label: S.of(context).system,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.article),
              label: S.of(context).reports,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: S.of(context).myProfile,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.support_agent),
              label: S.of(context).complaints,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: S.of(context).settings,
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
