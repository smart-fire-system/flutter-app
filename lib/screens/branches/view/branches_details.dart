import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:fire_alarm_system/widgets/info.dart';
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
              CustomInfoCard(
                title: "Branch Information",
                icon: Icons.info_outline,
                children: [
                  CustomInfoItem(
                    title: "Name",
                    value: widget.branch.name,
                  ),
                  CustomInfoItem(
                    title: "Code",
                    value: widget.branch.code.toString(),
                  ),
                  CustomInfoItem(
                    title: "Created At",
                    value: widget.branch.createdAt.toDate().toString(),
                  ),
                ],
              ),
              CustomInfoCard(
                title: "Company Information",
                icon: Icons.business_outlined,
                children: [
                  ListTile(
                    title: Text(widget.branch.company.name,
                        style: CustomStyle.smallTextB),
                    subtitle: Text(widget.branch.company.comment,
                        style: CustomStyle.smallText),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.branch.company.logoURL),
                      radius: 25.0,
                    ),
                  ),
                ],
              ),
              CustomInfoCard(
                title: "Contact Information",
                icon: Icons.contact_phone_outlined,
                children: [
                  CustomInfoItem(
                    title: "Phone",
                    value: widget.branch.phoneNumber,
                  ),
                  CustomInfoItem(
                    title: "Email",
                    value: widget.branch.email,
                  ),
                ],
              ),
              CustomInfoCard(
                title: "Address",
                icon: Icons.location_on_outlined,
                children: [
                  CustomInfoItem(
                    value: widget.branch.address,
                  ),
                ],
              ),
              if (widget.branch.comment.isNotEmpty)
                CustomInfoCard(
                  title: "Comment",
                  icon: Icons.comment_outlined,
                  children: [
                    CustomInfoItem(
                      value: widget.branch.comment,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
