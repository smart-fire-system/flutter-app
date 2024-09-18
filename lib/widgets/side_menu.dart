import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/l10n.dart';
import '../utils/localization_util.dart';
import '../utils/enums.dart';
import '../utils/general_util.dart';

class CustomSideMenu extends StatefulWidget {
  final ScreenType screen;
  final UserRole userRole;
  final String userName;
  final double? width;
  final bool Function()? preNavigationCallback;

  const CustomSideMenu({
    super.key,
    required this.screen,
    required this.userRole,
    required this.userName,
    this.width,
    this.preNavigationCallback,
  });

  @override
  CustomSideMenuState createState() => CustomSideMenuState();
}

class CustomSideMenuState extends State<CustomSideMenu> {
  final TextStyle _fontStyle = GoogleFonts.cairo(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
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
                  widget.userName,
                  style: _fontStyle,
                ),
                leading: const Icon(
                  Icons.person,
                  size: 40,
                ),
                subtitle: Text(
                  GeneralUtil.getRoleName(widget.userRole), // Optional subtitle
                  style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
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
                  style: _fontStyle,
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
                  style: _fontStyle,
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
                  style: _fontStyle,
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
                  style: _fontStyle,
                ),
                leading: const Icon(
                  Icons.language,
                  color: Colors.black54,
                ),
                onTap: () {
                  LocalizationUtil.showEditLanguageDialog(context);
                },
              ),
              (widget.userRole == UserRole.admin ||
                      widget.userRole == UserRole.technican)
                  ? ExpansionTile(
                      title: Text(
                        S.of(context).system,
                        style: _fontStyle,
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            S.of(context).viewAndControlSystem,
                            style: _fontStyle,
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
                            style: _fontStyle,
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
                        style: _fontStyle,
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
                  style: _fontStyle,
                ),
                children: [
                  ListTile(
                    title: Text(
                      S.of(context).viewComplaints,
                      style: _fontStyle,
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
                      style: _fontStyle,
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
                  style: _fontStyle,
                ),
                children: [
                  ListTile(
                    title: Text(
                      S.of(context).visits,
                      style: _fontStyle,
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
                      style: _fontStyle,
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
                      style: _fontStyle,
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
                  style: _fontStyle,
                ),
                children: [
                  if (widget.userRole == UserRole.admin)
                    ListTile(
                      title: Text(
                        S.of(context).admins,
                        style: _fontStyle,
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
                  if (widget.userRole == UserRole.admin)
                    ListTile(
                      title: Text(
                        S.of(context).regionalManagers,
                        style: _fontStyle,
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
                  if (widget.userRole == UserRole.admin ||
                      widget.userRole == UserRole.regionalManager)
                    ListTile(
                      title: Text(
                        S.of(context).branchManagers,
                        style: _fontStyle,
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
                  if (widget.userRole == UserRole.admin ||
                      widget.userRole == UserRole.regionalManager ||
                      widget.userRole == UserRole.branchManager)
                    ListTile(
                      title: Text(
                        S.of(context).employees,
                        style: _fontStyle,
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
                  if (widget.userRole == UserRole.admin ||
                      widget.userRole == UserRole.regionalManager ||
                      widget.userRole == UserRole.branchManager)
                    ListTile(
                      title: Text(
                        S.of(context).technicans,
                        style: _fontStyle,
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
                  if (widget.userRole == UserRole.admin ||
                      widget.userRole == UserRole.regionalManager ||
                      widget.userRole == UserRole.branchManager ||
                      widget.userRole == UserRole.employee ||
                      widget.userRole == UserRole.technican)
                    ListTile(
                      title: Text(
                        S.of(context).clients,
                        style: _fontStyle,
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
          ListTile(
            title: Text(
              "About Developer",
              style: _fontStyle,
            ),
            tileColor: Colors.lightBlue[50],
            subtitle: Text(
              "Ahmed Hassan",
              style: _fontStyle,
            ),
            leading: const Icon(
              Icons.code,
              color: Colors.black54,
            ),
            onTap: () async {
              const url = 'ahmedhassandev.com';
              await launchUrl(Uri(scheme: 'https', path: url));
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
  void _defaultOnAdminsClick() {}
  void _defaultOnRegionalManagersClick() {}
  void _defaultOnBranchManagersClick() {}
  void _defaultOnEmployeesClick() {}
  void _defaultOnTechnicansClick() {}
  void _defaultOnClientsClick() {}
}
