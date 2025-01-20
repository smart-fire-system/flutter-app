import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';

enum CustomSideMenuItem {
  profile,
  home,
  notifications,
  viewSystem,
  configureSystem,
  viewComplaints,
  submitComplaints,
  visits,
  contracts,
  systemStatus,
  admins,
  companyManagers,
  branchManagers,
  employees,
  technicans,
  clients,
  logout,
}

class CustomSideMenu extends StatefulWidget {
  final CustomSideMenuItem highlightedItem;
  final User user;
  final double? width;
  final Future<void> Function(CustomSideMenuItem item)? onItemClick;
  final List<CustomSideMenuItem>? noActionItems;
  const CustomSideMenu({
    super.key,
    required this.highlightedItem,
    required this.user,
    this.width,
    this.onItemClick,
    this.noActionItems = const [],
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
                onTap: () async {
                  if (widget.onItemClick != null) {
                    await widget.onItemClick!(CustomSideMenuItem.profile);
                  }
                  if (!widget.noActionItems!
                      .contains(CustomSideMenuItem.profile)) {
                    _defaultOnProfileClick();
                  }
                },
              ),
              ListTile(
                title: Text(
                  S.of(context).home,
                  style: CustomStyle.smallText,
                ),
                selected: (widget.highlightedItem == CustomSideMenuItem.home),
                leading: const Icon(
                  Icons.home,
                  color: Colors.black54,
                ),
                onTap: () async {
                  if (widget.onItemClick != null) {
                    await widget.onItemClick!(CustomSideMenuItem.home);
                  }
                  if (!widget.noActionItems!
                      .contains(CustomSideMenuItem.home)) {
                    _defaultOnHomeClick();
                  }
                },
              ),
              ListTile(
                title: Text(
                  S.of(context).notifications,
                  style: CustomStyle.smallText,
                ),
                selected: (widget.highlightedItem ==
                    CustomSideMenuItem.notifications),
                leading: const Icon(
                  Icons.notifications,
                  color: Colors.black54,
                ),
                onTap: () async {
                  if (widget.onItemClick != null) {
                    await widget.onItemClick!(CustomSideMenuItem.notifications);
                  }
                  if (!widget.noActionItems!
                      .contains(CustomSideMenuItem.notifications)) {
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
              (widget.user.role == UserRole.admin)
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
                          selected: (widget.highlightedItem ==
                              CustomSideMenuItem.viewSystem),
                          leading: const Icon(
                            Icons.monitor,
                            color: Colors.black54,
                          ),
                          onTap: () async {
                            if (widget.onItemClick != null) {
                              await widget
                                  .onItemClick!(CustomSideMenuItem.viewSystem);
                            }
                            if (!widget.noActionItems!
                                .contains(CustomSideMenuItem.viewSystem)) {
                              _defaultOnViewSystemClick();
                            }
                          },
                        ),
                        ListTile(
                          title: Text(
                            S.of(context).manageAndConfigureSystem,
                            style: CustomStyle.smallText,
                          ),
                          selected: (widget.highlightedItem ==
                              CustomSideMenuItem.configureSystem),
                          leading: const Icon(
                            Icons.settings,
                            color: Colors.black54,
                          ),
                          onTap: () async {
                            if (widget.onItemClick != null) {
                              await widget.onItemClick!(
                                  CustomSideMenuItem.configureSystem);
                            }
                            if (!widget.noActionItems!
                                .contains(CustomSideMenuItem.configureSystem)) {
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
                      selected: (widget.highlightedItem ==
                          CustomSideMenuItem.viewSystem),
                      leading: const Icon(
                        Icons.monitor,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        if (widget.onItemClick != null) {
                          await widget
                              .onItemClick!(CustomSideMenuItem.viewSystem);
                        }
                        if (!widget.noActionItems!
                            .contains(CustomSideMenuItem.viewSystem)) {
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
                    selected: (widget.highlightedItem ==
                        CustomSideMenuItem.viewComplaints),
                    leading: const Icon(
                      Icons.feedback,
                      color: Colors.black54,
                    ),
                    onTap: () async {
                      if (widget.onItemClick != null) {
                        await widget
                            .onItemClick!(CustomSideMenuItem.viewComplaints);
                      }
                      if (!widget.noActionItems!
                          .contains(CustomSideMenuItem.viewComplaints)) {
                        _defaultOnViewComplaintsClick();
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).submitComplaint,
                      style: CustomStyle.smallText,
                    ),
                    selected: (widget.highlightedItem ==
                        CustomSideMenuItem.submitComplaints),
                    leading: const Icon(
                      Icons.add,
                      color: Colors.black54,
                    ),
                    onTap: () async {
                      if (widget.onItemClick != null) {
                        await widget
                            .onItemClick!(CustomSideMenuItem.submitComplaints);
                      }
                      if (!widget.noActionItems!
                          .contains(CustomSideMenuItem.submitComplaints)) {
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
                    selected:
                        (widget.highlightedItem == CustomSideMenuItem.visits),
                    leading: const Icon(
                      Icons.note,
                      color: Colors.black54,
                    ),
                    onTap: () async {
                      if (widget.onItemClick != null) {
                        await widget.onItemClick!(CustomSideMenuItem.visits);
                      }
                      if (!widget.noActionItems!
                          .contains(CustomSideMenuItem.visits)) {
                        _defaultOnVisitsClick();
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).maintenanceContracts,
                      style: CustomStyle.smallText,
                    ),
                    selected: (widget.highlightedItem ==
                        CustomSideMenuItem.contracts),
                    leading: const Icon(
                      Icons.note,
                      color: Colors.black54,
                    ),
                    onTap: () async {
                      if (widget.onItemClick != null) {
                        await widget.onItemClick!(CustomSideMenuItem.contracts);
                      }
                      if (!widget.noActionItems!
                          .contains(CustomSideMenuItem.contracts)) {
                        _defaultOnContractsClick();
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).systemStatusAndFaults,
                      style: CustomStyle.smallText,
                    ),
                    selected: (widget.highlightedItem ==
                        CustomSideMenuItem.systemStatus),
                    leading: const Icon(
                      Icons.note,
                      color: Colors.black54,
                    ),
                    onTap: () async {
                      if (widget.onItemClick != null) {
                        await widget
                            .onItemClick!(CustomSideMenuItem.systemStatus);
                      }
                      if (!widget.noActionItems!
                          .contains(CustomSideMenuItem.systemStatus)) {
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
                      selected:
                          (widget.highlightedItem == CustomSideMenuItem.admins),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        if (widget.onItemClick != null) {
                          await widget.onItemClick!(CustomSideMenuItem.admins);
                        }
                        if (!widget.noActionItems!
                            .contains(CustomSideMenuItem.admins)) {
                          _defaultOnAdminsClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin)
                    ListTile(
                      title: Text(
                        S.of(context).companyManagers,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.highlightedItem ==
                          CustomSideMenuItem.companyManagers),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        if (widget.onItemClick != null) {
                          await widget.onItemClick!(
                              CustomSideMenuItem.companyManagers);
                        }
                        if (!widget.noActionItems!
                            .contains(CustomSideMenuItem.companyManagers)) {
                          _defaultOnRegionalManagersClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.companyManager)
                    ListTile(
                      title: Text(
                        S.of(context).branchManagers,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.highlightedItem ==
                          CustomSideMenuItem.branchManagers),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        if (widget.onItemClick != null) {
                          await widget
                              .onItemClick!(CustomSideMenuItem.branchManagers);
                        }
                        if (!widget.noActionItems!
                            .contains(CustomSideMenuItem.branchManagers)) {
                          _defaultOnBranchManagersClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.companyManager ||
                      widget.user.role == UserRole.branchManager)
                    ListTile(
                      title: Text(
                        S.of(context).employees,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.highlightedItem ==
                          CustomSideMenuItem.employees),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        if (widget.onItemClick != null) {
                          await widget
                              .onItemClick!(CustomSideMenuItem.employees);
                        }
                        if (!widget.noActionItems!
                            .contains(CustomSideMenuItem.employees)) {
                          _defaultOnEmployeesClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.companyManager ||
                      widget.user.role == UserRole.branchManager)
                    ListTile(
                      title: Text(
                        S.of(context).technicans,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.highlightedItem ==
                          CustomSideMenuItem.technicans),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        if (widget.onItemClick != null) {
                          await widget
                              .onItemClick!(CustomSideMenuItem.technicans);
                        }
                        if (!widget.noActionItems!
                            .contains(CustomSideMenuItem.technicans)) {
                          _defaultOnTechnicansClick();
                        }
                      },
                    ),
                  if (widget.user.role == UserRole.admin ||
                      widget.user.role == UserRole.companyManager ||
                      widget.user.role == UserRole.branchManager ||
                      widget.user.role == UserRole.employee)
                    ListTile(
                      title: Text(
                        S.of(context).clients,
                        style: CustomStyle.smallText,
                      ),
                      selected: (widget.highlightedItem ==
                          CustomSideMenuItem.clients),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                      ),
                      onTap: () async {
                        if (widget.onItemClick != null) {
                          await widget.onItemClick!(CustomSideMenuItem.clients);
                        }
                        if (!widget.noActionItems!
                            .contains(CustomSideMenuItem.clients)) {
                          _defaultOnClientsClick();
                        }
                      },
                    ),
                ],
              ),
              ListTile(
                title: Text(
                  S.of(context).logout,
                  style: CustomStyle.smallText,
                ),
                selected: false,
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black54,
                ),
                onTap: () async {
                  if (widget.onItemClick != null) {
                    await widget.onItemClick!(CustomSideMenuItem.logout);
                  }
                  if (!widget.noActionItems!
                      .contains(CustomSideMenuItem.logout)) {
                    _defaultOnLogoutClick();
                  }
                },
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
                await launchUrl(Uri.parse('https://ahmedhassandev.com'));
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
  void _defaultOnProfileClick() {
    Navigator.pushNamed(context, '/profile');
  }

  void _defaultOnNotificationsClick() {}
  void _defaultOnViewSystemClick() {}
  void _defaultOnConfigureSystemClick() {}
  void _defaultOnViewComplaintsClick() {}
  void _defaultOnSubmitComplaintClick() {}
  void _defaultOnVisitsClick() {}
  void _defaultOnContractsClick() {}
  void _defaultOnSystemStatusClick() {}
  void _defaultOnAdminsClick() {
    Navigator.pushNamed(context, '/admins');
  }

  void _defaultOnRegionalManagersClick() {}
  void _defaultOnBranchManagersClick() {}
  void _defaultOnEmployeesClick() {}
  void _defaultOnTechnicansClick() {}
  void _defaultOnClientsClick() {}
  void _defaultOnLogoutClick() async {
    try {
      await AuthRepository().signOut();
    } catch (error) {
      // Do Nothing.
    }
  }
}
