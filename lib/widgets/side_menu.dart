import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';
import 'package:fire_alarm_system/models/user_auth.dart';

enum ScreenType {
  welcome,
  login,
  signup,
  home,
  profile,
  notifications,
  viewSystem,
  configureSystem,
  viewComplaints,
  submitComplaints,
  visits,
  contracts,
  systemStatus,
  admins,
  regionalManagers,
  branchManagers,
  employees,
  technicans,
  clients,
}

class CustomSideMenu extends StatefulWidget {
  final ScreenType screen;
  final User user;
  final double? width;
  final bool Function()? preNavigationCallback;

  const CustomSideMenu({
    super.key,
    required this.screen,
    required this.user,
    this.width,
    this.preNavigationCallback,
  });

  @override
  CustomSideMenuState createState() => CustomSideMenuState();
}

class CustomSideMenuState extends State<CustomSideMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 300.0,
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              ListTile(
                title: Text(
                  widget.user.name,
                  style: CustomStyle.smallText,
                ),
                leading: const Icon(
                  Icons.person,
                  size: 40,
                ),
                subtitle: Text(
                  User.getRoleName(context, widget.user.role),
                  style: CustomStyle.smallTextGrey,
                ),
                onTap: () {
                  if (widget.preNavigationCallback == null) {
                    _defaultOnProfileClick();
                  } else if (widget.preNavigationCallback!()) {
                    _defaultOnProfileClick();
                  }
                },
              ),
              ListTile(
                title: Text(
                  S.of(context).home,
                  style: CustomStyle.smallText,
                ),
                selected: (widget.screen == ScreenType.home),
                leading: const Icon(
                  Icons.home,
                  color: Colors.black54,
                ),
                onTap: () {
                  if (widget.preNavigationCallback == null) {
                    _defaultOnHomeClick();
                  } else if (widget.preNavigationCallback!()) {
                    _defaultOnHomeClick();
                  }
                },
              ),
              ListTile(
                title: Text(
                  S.of(context).profile,
                  style: CustomStyle.smallText,
                ),
                selected: (widget.screen == ScreenType.profile),
                leading: const Icon(
                  Icons.person,
                  color: Colors.black54,
                ),
                onTap: () {
                  if (widget.preNavigationCallback == null) {
                    _defaultOnProfileClick();
                  } else if (widget.preNavigationCallback!()) {
                    _defaultOnProfileClick();
                  }
                },
              ),
              ListTile(
                title: Text(
                  S.of(context).notifications,
                  style: CustomStyle.smallText,
                ),
                selected: (widget.screen == ScreenType.notifications),
                leading: const Icon(
                  Icons.notifications,
                  color: Colors.black54,
                ),
                onTap: () {
                  if (widget.preNavigationCallback == null) {
                    _defaultOnNotificationsClick();
                  } else if (widget.preNavigationCallback!()) {
                    _defaultOnNotificationsClick();
                  }
                },
              ),
              ListTile(
                title: Text(
                  S.of(context).changeLanguage,
                  style: CustomStyle.smallText,
                ),
                leading: const Icon(
                  Icons.language,
                  color: Colors.black54,
                ),
                onTap: () {
                  LocalizationUtil.showEditLanguageDialog(context);
                },
              ),
              (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.technican)
                  ? ExpansionTile(
                      title: Text(
                        S.of(context).system,
                        style: CustomStyle.smallText,
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            S.of(context).viewAndControlSystem,
                            style: CustomStyle.smallText,
                          ),
                          selected: (widget.screen == ScreenType.viewSystem),
                          leading: const Icon(
                            Icons.monitor,
                            color: Colors.black54,
                          ),
                          onTap: () {
                            if (widget.preNavigationCallback == null) {
                              _defaultOnViewSystemClick();
                            } else if (widget.preNavigationCallback!()) {
                              _defaultOnViewSystemClick();
                            }
                          },
                        ),
                        ListTile(
                          title: Text(
                            S.of(context).manageAndConfigureSystem,
                            style: CustomStyle.smallText,
                          ),
                          selected:
                              (widget.screen == ScreenType.configureSystem),
                          leading: const Icon(
                            Icons.settings,
                            color: Colors.black54,
                          ),
                          onTap: () {
                            if (widget.preNavigationCallback == null) {
                              _defaultOnConfigureSystemClick();
                            } else if (widget.preNavigationCallback!()) {
                              _defaultOnConfigureSystemClick();
                            }
                          },
                        ),
                      ],
                    )
                  : ListTile(
                      title: Text(
                        S.of(context).viewAndControlSystem,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.screen == ScreenType.viewSystem),
                      leading: const Icon(
                        Icons.monitor,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        if (widget.preNavigationCallback == null) {
                          _defaultOnViewSystemClick();
                        } else if (widget.preNavigationCallback!()) {
                          _defaultOnViewSystemClick();
                        }
                      },
                    ),
              ExpansionTile(
                title: Text(
                  S.of(context).complaints,
                  style: CustomStyle.smallText,
                ),
                children: [
                  ListTile(
                    title: Text(
                      S.of(context).viewComplaints,
                      style: CustomStyle.smallText,
                    ),
                    selected: (widget.screen == ScreenType.viewComplaints),
                    leading: const Icon(
                      Icons.feedback,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      if (widget.preNavigationCallback == null) {
                        _defaultOnViewComplaintsClick();
                      } else if (widget.preNavigationCallback!()) {
                        _defaultOnViewComplaintsClick();
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).submitComplaint,
                      style: CustomStyle.smallText,
                    ),
                    selected: (widget.screen == ScreenType.submitComplaints),
                    leading: const Icon(
                      Icons.add,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      if (widget.preNavigationCallback == null) {
                        _defaultOnSubmitComplaintClick();
                      } else if (widget.preNavigationCallback!()) {
                        _defaultOnSubmitComplaintClick();
                      }
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  S.of(context).reports,
                  style: CustomStyle.smallText,
                ),
                children: [
                  ListTile(
                    title: Text(
                      S.of(context).visits,
                      style: CustomStyle.smallText,
                    ),
                    selected: (widget.screen == ScreenType.visits),
                    leading: const Icon(
                      Icons.note,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      if (widget.preNavigationCallback == null) {
                        _defaultOnVisitsClick();
                      } else if (widget.preNavigationCallback!()) {
                        _defaultOnVisitsClick();
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).maintenanceContracts,
                      style: CustomStyle.smallText,
                    ),
                    selected: (widget.screen == ScreenType.contracts),
                    leading: const Icon(
                      Icons.note,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      if (widget.preNavigationCallback == null) {
                        _defaultOnContractsClick();
                      } else if (widget.preNavigationCallback!()) {
                        _defaultOnContractsClick();
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).systemStatusAndFaults,
                      style: CustomStyle.smallText,
                    ),
                    selected: (widget.screen == ScreenType.systemStatus),
                    leading: const Icon(
                      Icons.note,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      if (widget.preNavigationCallback == null) {
                        _defaultOnSystemStatusClick();
                      } else if (widget.preNavigationCallback!()) {
                        _defaultOnSystemStatusClick();
                      }
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  S.of(context).users,
                  style: CustomStyle.smallText,
                ),
                children: [
                  if (widget.user.role == UserRole.admin)
                    ListTile(
                      title: Text(
                        S.of(context).admins,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.screen == ScreenType.admins),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        if (widget.preNavigationCallback == null) {
                          _defaultOnAdminsClick();
                        } else if (widget.preNavigationCallback!()) {
                          _defaultOnAdminsClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin)
                    ListTile(
                      title: Text(
                        S.of(context).regionalManagers,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.screen == ScreenType.regionalManagers),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        if (widget.preNavigationCallback == null) {
                          _defaultOnRegionalManagersClick();
                        } else if (widget.preNavigationCallback!()) {
                          _defaultOnRegionalManagersClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.regionalManager)
                    ListTile(
                      title: Text(
                        S.of(context).branchManagers,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.screen == ScreenType.branchManagers),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        if (widget.preNavigationCallback == null) {
                          _defaultOnBranchManagersClick();
                        } else if (widget.preNavigationCallback!()) {
                          _defaultOnBranchManagersClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.regionalManager ||
                      widget.user.role == UserRole.branchManager)
                    ListTile(
                      title: Text(
                        S.of(context).employees,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.screen == ScreenType.employees),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        if (widget.preNavigationCallback == null) {
                          _defaultOnEmployeesClick();
                        } else if (widget.preNavigationCallback!()) {
                          _defaultOnEmployeesClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.regionalManager ||
                      widget.user.role == UserRole.branchManager)
                    ListTile(
                      title: Text(
                        S.of(context).technicans,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.screen == ScreenType.technicans),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        if (widget.preNavigationCallback == null) {
                          _defaultOnTechnicansClick();
                        } else if (widget.preNavigationCallback!()) {
                          _defaultOnTechnicansClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.regionalManager ||
                      widget.user.role == UserRole.branchManager ||
                      widget.user.role == UserRole.employee ||
                      widget.user.role == UserRole.technican)
                    ListTile(
                      title: Text(
                        S.of(context).clients,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.screen == ScreenType.clients),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () {
                        if (widget.preNavigationCallback == null) {
                          _defaultOnClientsClick();
                        } else if (widget.preNavigationCallback!()) {
                          _defaultOnClientsClick();
                        }
                      },
                    ),
                ],
              ),
            ]),
          ),
          const Divider(
            thickness: 3,
          ),
          ListTile(
            title: Text(
              "About Developer",
              style: CustomStyle.smallText,
            ),
            subtitle: Text(
              "Ahmed Hassan",
              style: CustomStyle.smallTextGrey,
            ),
            leading: const Icon(
              Icons.code,
              color: Colors.black54,
            ),
            onTap: () async {
              try {
                const url = 'ahmedhassandev.com';
                await launchUrl(Uri(scheme: 'https', path: url), webOnlyWindowName: "_blank" );
              } catch (error) {
                // No launch
              }
            },
          ),
        ],
      ),
    );
  }

  void _defaultOnHomeClick() {}
  void _defaultOnProfileClick() {}
  void _defaultOnNotificationsClick() {}
  void _defaultOnViewSystemClick() {}
  void _defaultOnConfigureSystemClick() {}
  void _defaultOnViewComplaintsClick() {}
  void _defaultOnSubmitComplaintClick() {}
  void _defaultOnVisitsClick() {}
  void _defaultOnContractsClick() {}
  void _defaultOnSystemStatusClick() {}
  void _defaultOnAdminsClick() {Navigator.pushNamed(context, '/admins');}
  void _defaultOnRegionalManagersClick() {}
  void _defaultOnBranchManagersClick() {}
  void _defaultOnEmployeesClick() {}
  void _defaultOnTechnicansClick() {}
  void _defaultOnClientsClick() {}
}
