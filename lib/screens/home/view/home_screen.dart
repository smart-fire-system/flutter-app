import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'dart:async';
import 'package:fire_alarm_system/screens/home/view/add_phone_screen.dart';
import 'package:fire_alarm_system/screens/home/view/error_screen.dart';
import 'package:fire_alarm_system/screens/home/view/login_screen.dart';
import 'package:fire_alarm_system/screens/home/view/not_authorized_screen.dart';
import 'package:fire_alarm_system/screens/home/view/update_needed_screen.dart';
import 'package:fire_alarm_system/screens/notifications/view/notifications_screen.dart';
import 'package:fire_alarm_system/screens/home/view/signup_screen.dart';
import 'package:fire_alarm_system/screens/home/view/welcome_screen.dart';
import 'package:fire_alarm_system/utils/errors.dart';
import 'package:fire_alarm_system/utils/message.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  OverlayEntry? _notificationOverlay;
  Timer? _notificationOverlayTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _removeTopNotificationBanner();
    super.dispose();
  }

  void setCurrentTab(AppTab tab) {
    setState(() {
      _currentTab = AppTab.values[tab.index];
      _activeTabs.remove(_currentTab);
      _activeTabs.add(_currentTab);
      if (_activeTabs.length > 1) {
        _canPop = false;
      }
    });
  }

  void clearStack() {
    setState(() {
      TabNavigator.system.currentState?.popUntil((route) => route.isFirst);
      TabNavigator.reports.currentState?.popUntil((route) => route.isFirst);
      TabNavigator.home.currentState?.popUntil((route) => route.isFirst);
      TabNavigator.profile.currentState?.popUntil((route) => route.isFirst);
      TabNavigator.usersAndBranches.currentState
          ?.popUntil((route) => route.isFirst);
      _activeTabs.clear();
      _currentTab = AppTab.home;
      _activeTabs.add(_currentTab);
      _canPop = true;
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

  GlobalKey<NavigatorState> _navigatorKeyFor(AppTab tab) {
    switch (tab) {
      case AppTab.system:
        return TabNavigator.system;
      case AppTab.reports:
        return TabNavigator.reports;
      case AppTab.home:
        return TabNavigator.home;
      case AppTab.usersAndBranches:
        return TabNavigator.usersAndBranches;
      case AppTab.profile:
        return TabNavigator.profile;
    }
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _currentTab.index == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? CustomStyle.redDark.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeUpdateNeeded) {
          _showAlert(
            context: context,
            message: state.message,
            error: state.error,
          );
          state.error = null;
          state.message = null;
          return buildUpdateNeeded(context, state.appVersionData);
        }
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
          if (state.notificationReceived != null) {
            final title = state.notificationReceived!.enTitle;
            final body = state.notificationReceived!.enBody;
            state.notificationReceived = null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).clearMaterialBanners();
              _showTopNotificationBanner(
                context: context,
                title: title,
                body: body,
                onView: () {
                  _removeTopNotificationBanner();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              );
            });
          }
          if (state.openNotifications) {
            state.openNotifications = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen()),
              );
            });
          }
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
        } else if (state is HomeError) {
          IconData icon = Icons.error_outline_rounded;
          String errorMessage = state.error.toString();
          if (state.error == AuthChangeResult.networkError) {
            errorMessage = l10n.network_error;
            icon = Icons.wifi_off_rounded;
          } else if (state.error == AuthChangeResult.generalError) {
            errorMessage = l10n.unknown_error;
            icon = Icons.error_outline_rounded;
          }
          return ErrorScreen(
            onRefreshClick: () {
              context.read<HomeBloc>().add(RefreshRequested());
            },
            errorMessage: errorMessage,
            icon: icon,
          );
        }
        return const CustomLoading();
      },
    );
  }

  void _removeTopNotificationBanner() {
    _notificationOverlayTimer?.cancel();
    _notificationOverlayTimer = null;
    _notificationOverlay?.remove();
    _notificationOverlay = null;
  }

  void _showTopNotificationBanner({
    required BuildContext context,
    required String title,
    required String body,
    VoidCallback? onView,
    Duration duration = const Duration(seconds: 10),
  }) {
    _removeTopNotificationBanner();
    final overlay = Overlay.of(context, rootOverlay: true);

    _notificationOverlay = OverlayEntry(
      builder: (ctx) {
        return SafeArea(
          top: true,
          child: Align(
            alignment: Alignment.topCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: -1.0, end: 0.0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value * 100),
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: Colors.transparent,
                  child: Dismissible(
                    key: const Key('notification_banner'),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      _removeTopNotificationBanner();
                    },
                    child: GestureDetector(
                      onTap: onView,
                      onVerticalDragEnd: (_) {
                        _removeTopNotificationBanner();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CustomStyle.greyDark,
                              CustomStyle.greyDark.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.notifications_active_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        title.isEmpty ? 'Notification' : title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (body.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          body,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              _removeTopNotificationBanner();
                                            },
                                            child: const Text('DISMISS'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor:
                                                  CustomStyle.redDark,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 10,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              if (onView != null) onView();
                                            },
                                            child: const Text(
                                              'VIEW',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: _removeTopNotificationBanner,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 4, top: 2),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_notificationOverlay!);

    _notificationOverlayTimer = Timer(duration, () {
      _removeTopNotificationBanner();
    });
  }

  Widget _buildHome(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        children: const [
          TabNavigator(screen: AppTab.system),
          TabNavigator(screen: AppTab.reports),
          TabNavigator(screen: AppTab.home),
          TabNavigator(screen: AppTab.usersAndBranches),
          TabNavigator(screen: AppTab.profile),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: Colors.white,
            selectedItemColor: CustomStyle.redDark,
            unselectedItemColor: const Color(0xFF9CA3AF),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: _currentTab.index,
            onTap: (int newIndex) {
              final AppTab tappedTab = AppTab.values[newIndex];
              final navigatorKey = _navigatorKeyFor(tappedTab);
              if (_currentTab.index == newIndex) {
                navigatorKey.currentState?.popUntil((route) => route.isFirst);
                return;
              }
              setState(() {
                _currentTab = tappedTab;
                _activeTabs.remove(_currentTab);
                _activeTabs.add(_currentTab);
                if (_activeTabs.length > 1) {
                  _canPop = false;
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.bar_chart_rounded, 0),
                label: l10n.system,
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.article_rounded, 1),
                label: l10n.reports,
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.home_rounded, 2),
                label: l10n.home,
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.people_alt_rounded, 3),
                label: l10n.users_and_branches,
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.person, 4),
                label: l10n.profile,
              ),
            ],
          ),
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
