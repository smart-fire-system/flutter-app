import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BranchDetails extends StatefulWidget {
  final Branch branch;
  const BranchDetails({super.key, required this.branch});

  @override
  BranchDetailsState createState() => BranchDetailsState();
}

class BranchDetailsState extends State<BranchDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        return _buildDetails(context);
      },
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.branch.name),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomStyle.redDark,
        onPressed: () async {
          final updatedBranch = await TabNavigator.settings.currentState
              ?.pushNamed('/branches/edit', arguments: widget.branch);
          if (updatedBranch != null && updatedBranch is Branch) {
            setState(() {
              // Update the branch details with the edited values
              widget.branch.name = updatedBranch.name;
              widget.branch.address = updatedBranch.address;
              widget.branch.phoneNumber = updatedBranch.phoneNumber;
              widget.branch.email = updatedBranch.email;
              widget.branch.comment = updatedBranch.comment;
            });
          }
        },
        icon: const Icon(
          Icons.edit,
          size: 30,
          color: Colors.white,
        ),
        label: Text("Edit", style: CustomStyle.mediumTextWhite),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Branch Information Card
              buildCard(
                title: "Branch Information",
                icon: Icons.info_outline,
                children: [
                  buildRow("Name", widget.branch.name),
                  buildRow("Code", widget.branch.code.toString()),
                  buildRow("Created At",
                      widget.branch.createdAt.toDate().toString()),
                ],
              ),

              // Contact Information Card
              buildCard(
                title: "Contact Information",
                icon: Icons.contact_phone_outlined,
                children: [
                  buildRow("Phone", widget.branch.phoneNumber),
                  buildRow("Email", widget.branch.email),
                ],
              ),

              // Address Card
              buildCard(
                title: "Address",
                icon: Icons.location_on_outlined,
                children: [
                  Text(
                    widget.branch.address,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),

              // Comment Section
              if (widget.branch.comment.isNotEmpty)
                buildCard(
                  title: "Comment",
                  icon: Icons.comment_outlined,
                  children: [
                    Text(
                      widget.branch.comment.isNotEmpty
                          ? widget.branch.comment
                          : "No comments available",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),

              // Company Information Card
              buildCard(
                title: "Company Information",
                icon: Icons.business_outlined,
                children: [
                  buildRow("Company Name", widget.branch.company.name),
                  if (widget.branch.company.comment.isNotEmpty)
                    Text(
                      widget.branch.company.comment,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a Card Section
  Widget buildCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: CustomStyle.redDark),
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style: CustomStyle.mediumTextBRed,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            ...children,
          ],
        ),
      ),
    );
  }

  // Build a Row for Key-Value Pairs
  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: CustomStyle.smallTextB,
          ),
          Expanded(
            child: Text(
              value,
              style: CustomStyle.smallText,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
