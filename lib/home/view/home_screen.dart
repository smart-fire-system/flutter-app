import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../generated/l10n.dart';
import '../../utils/enums.dart';
import '../../widgets/side_menu.dart';
import '../../utils/localization_util.dart';
import '../../utils/data_validator_util.dart';
import '../../repositories/auth_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _showSideMenu = false;
  UserRole role = UserRole.admin;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showSideMenu = (MediaQuery.of(context).size.width > 600);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextStyle fontStyle = GoogleFonts.cairo(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
    final TextStyle titleFontStyle = GoogleFonts.cairo(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700);
    final TextStyle appBarFontStyle = GoogleFonts.cairo(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).home,
          style: appBarFontStyle,
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
            setState(() {
              _showSideMenu = !_showSideMenu;
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
      body: Row(
        children: [
          _showSideMenu
              ? const CustomSideMenu(
                  screen: ScreenType.home,
                  userRole: UserRole.admin,
                  userName: "John Doe",
                  width: 300,
                )
              : Container(),
          role == UserRole.noAccess
              ? Container()
              : Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (MediaQuery.of(context).size.width < 600 &&
                          _showSideMenu) {
                        setState(() {
                          _showSideMenu = false;
                        });
                      }
                    },
                    child: (_showSideMenu && screenWidth < 500)
                        ? Container(color: Colors.transparent)
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: <Widget>[
                                Text(
                                  S.of(context).app_name,
                                  style: appBarFontStyle,
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.lightBlue[100],
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: const FaIcon(
                                              FontAwesomeIcons
                                                  .magnifyingGlassChart,
                                              color: Colors.black),
                                          title: Text(
                                            S
                                                .of(context)
                                                .system_monitoring_control,
                                            style: titleFontStyle,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            S
                                                .of(context)
                                                .system_monitoring_description,
                                            style: fontStyle,
                                          ),
                                        ),
                                        Wrap(
                                          children: [
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
                                                        .viewAndControlSystem,
                                                    style: fontStyle),
                                              ),
                                            ),
                                            if (role == UserRole.admin ||
                                                role == UserRole.technican)
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
                                                          .manageAndConfigureSystem,
                                                      style: fontStyle),
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
                                    color: Colors.lightBlue[100],
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.summarize,
                                              color: Colors.black),
                                          title: Text(S.of(context).reports,
                                              style: titleFontStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            S.of(context).reportsDescription,
                                            style: fontStyle,
                                          ),
                                        ),
                                        Wrap(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Perform some action
                                                },
                                                child: Text(
                                                    S.of(context).visits,
                                                    style: fontStyle),
                                              ),
                                            ),
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
                                                        .maintenanceContracts,
                                                    style: fontStyle),
                                              ),
                                            ),
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
                                                        .systemStatusAndFaults,
                                                    style: fontStyle),
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
                                    color: Colors.lightBlue[100],
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.feedback,
                                              color: Colors.black),
                                          title: Text(S.of(context).complaints,
                                              style: titleFontStyle),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                              S
                                                  .of(context)
                                                  .complaintsDescription,
                                              style: fontStyle),
                                        ),
                                        Wrap(
                                          children: [
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
                                                        .viewComplaints,
                                                    style: fontStyle),
                                              ),
                                            ),
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
                                                        .submitComplaint,
                                                    style: fontStyle),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (role == UserRole.admin ||
                                    role == UserRole.regionalManager ||
                                    role == UserRole.branchManager ||
                                    role == UserRole.employee ||
                                    role == UserRole.technican)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.lightBlue[100],
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.group,
                                                color: Colors.black),
                                            title: Text(S.of(context).users,
                                                style: titleFontStyle),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                                S.of(context).usersDescription,
                                                style: fontStyle),
                                          ),
                                          Wrap(
                                            children: [
                                              if (role == UserRole.admin)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      // Perform some action
                                                    },
                                                    child: Text(
                                                        S.of(context).admins,
                                                        style: fontStyle),
                                                  ),
                                                ),
                                              if (role == UserRole.admin)
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
                                                        style: fontStyle),
                                                  ),
                                                ),
                                              if (role == UserRole.admin ||
                                                  role ==
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
                                                        style: fontStyle),
                                                  ),
                                                ),
                                              if (role == UserRole.admin ||
                                                  role ==
                                                      UserRole
                                                          .regionalManager ||
                                                  role ==
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
                                                        style: fontStyle),
                                                  ),
                                                ),
                                              if (role == UserRole.admin ||
                                                  role ==
                                                      UserRole
                                                          .regionalManager ||
                                                  role ==
                                                      UserRole.branchManager)
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
                                                            .technicans,
                                                        style: fontStyle),
                                                  ),
                                                ),
                                              if (role == UserRole.admin ||
                                                  role ==
                                                      UserRole
                                                          .regionalManager ||
                                                  role ==
                                                      UserRole.branchManager ||
                                                  role == UserRole.employee ||
                                                  role == UserRole.technican)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      // Perform some action
                                                    },
                                                    child: Text(
                                                        S.of(context).clients,
                                                        style: fontStyle),
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
    );
  }
}
