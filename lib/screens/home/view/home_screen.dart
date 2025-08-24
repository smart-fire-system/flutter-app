import 'package:fire_alarm_system/screens/home/view/add_phone_screen.dart';
import 'package:fire_alarm_system/screens/home/view/login_screen.dart';
import 'package:fire_alarm_system/screens/home/view/not_authorized_screen.dart';
import 'package:fire_alarm_system/screens/home/view/signup_screen.dart';
import 'package:fire_alarm_system/screens/home/view/welcome_screen.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/utils/message.dart';
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

final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  dynamic _user;
  UserInfo _userInfo = UserInfo();
  AppTab _currentTab = AppTab.home;
  final List<AppTab> _activeTabs = [AppTab.home];
  bool _canPop = true;
  bool? _viewLoginScreen;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setCurrentTab(AppTab tab) {
    setState(() {
      _currentTab = tab;
    });
  }

  AppTab getCurrentTab() {
    return _currentTab;
  }

  void goBack() {
    setState(() {
      if (_activeTabs.length > 1) {
        _activeTabs.removeLast();
        _currentTab = _activeTabs.last;
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
          _showAlert(
            context: context,
            message: state.message,
            error: state.error,
          );
          state.error = null;
          state.message = null;
          return _buildNotAuthenticated(context);
        } else if (state is HomeNotAuthorized) {
          _showAlert(
            context: context,
            message: state.message,
            error: state.error,
          );
          state.error = null;
          state.message = null;
          _user = state.user;
          _userInfo = _user.info as UserInfo;
          return _buildNotAuthorized(
            context,
            state.isEmailVerified,
          );
        } else if (state is HomeAuthenticated) {
          _showAlert(
            context: context,
            message: state.message,
            error: state.error,
          );
          state.error = null;
          state.message = null;
          _user = state.user;
          _userInfo = _user.info as UserInfo;
          return _buildHome(context);
        }
        return const CustomLoading();
      },
    );
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        children: const [
          TabNavigator(screen: AppTab.system),
          TabNavigator(screen: AppTab.reports),
          TabNavigator(screen: AppTab.home),
          TabNavigator(screen: AppTab.complaints),
          TabNavigator(screen: AppTab.profile),
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
          currentIndex: _currentTab.index,
          onTap: (int newIndex) {
            setState(() {
              _currentTab = AppTab.values[newIndex];
              _activeTabs.remove(_currentTab);
              _activeTabs.add(_currentTab);
              if (_activeTabs.length > 1) {
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
              icon: const Icon(Icons.home),
              label: S.of(context).home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.support_agent),
              label: S.of(context).complaints,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: S.of(context).myProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotAuthenticated(BuildContext context) {
    if (_viewLoginScreen == null) {
      return WelcomeScreen(
        onLoginClick: () {
          setState(() {
            _viewLoginScreen = true;
          });
        },
        onSignUpClick: () {
          setState(() {
            _viewLoginScreen = false;
          });
        },
        onGoogleLoginClick: () {
          context.read<HomeBloc>().add(GoogleLoginRequested());
        },
      );
    } else if (_viewLoginScreen == true) {
      return LoginScreen(
        onLoginClick: (String email, String password) {
          context.read<HomeBloc>().add(LoginRequested(
                email: email,
                password: password,
              ));
        },
        onGoogleLoginClick: () {
          context.read<HomeBloc>().add(
                GoogleLoginRequested(),
              );
        },
        onSignUpClick: () {
          setState(() {
            _viewLoginScreen = false;
          });
        },
        onResetPasswordClick: () {
          context.read<HomeBloc>().add(ResetPasswordRequested());
        },
      );
    } else {
      return SignUpScreen(
        onSignUpClick: (String name, String email, String password) {
          context.read<HomeBloc>().add(SignUpRequested(
                name: name,
                email: email,
                password: password,
              ));
        },
        onGoogleLoginClick: () {
          context.read<HomeBloc>().add(
                GoogleLoginRequested(),
              );
        },
        onLoginClick: () {
          setState(() {
            _viewLoginScreen = true;
          });
        },
      );
    }
  }

  Widget _buildNotAuthorized(BuildContext context, bool isEmailVerified) {
    return NotAuthorizedScreen(
      email: _userInfo.email,
      name: _userInfo.name,
      role: _user.permissions.role == null
          ? null
          : UserInfo.getRoleName(context, _user.permissions.role),
      isEmailVerified: isEmailVerified,
      isPhoneAdded: _userInfo.phoneNumber.isNotEmpty,
      onRefresh: () {
        context.read<HomeBloc>().add(RefreshRequested());
      },
      onConfirmEmailClick: () {
        context.read<HomeBloc>().add(ResendEmailRequested());
      },
      onAddPhoneNumberClick: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPhoneScreen(
              name: _userInfo.name,
              onSaveClick:
                  (String name, String phoneNumber, String countryCode) {
                Navigator.pop(context);
                context.read<HomeBloc>().add(UpdatePhoneNumberRequested(
                      name: name,
                      phoneNumber: phoneNumber,
                      countryCode: countryCode,
                    ));
              },
            ),
          ),
        );
      },
      onLogoutClick: () {
        context.read<HomeBloc>().add(LogoutRequested());
      },
    );
  }

  void _showAlert({
    required BuildContext context,
    AppMessage? message,
    String? error,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (message != null) {
        CustomAlert.showSuccess(
          context: context,
          title: message.getText(context),
        );
      } else if (error != null) {
        CustomAlert.showError(
          context: context,
          title: Errors.getFirebaseErrorMessage(
            context,
            error,
          ),
        );
      }
    });
  }
}
