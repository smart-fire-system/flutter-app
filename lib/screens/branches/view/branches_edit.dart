import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

import 'package:fire_alarm_system/screens/branches/bloc/bloc.dart';
import 'package:fire_alarm_system/screens/branches/bloc/event.dart';
import 'package:fire_alarm_system/screens/branches/bloc/state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditBranchScreen extends StatefulWidget {
  final Branch branch;
  const EditBranchScreen({super.key, required this.branch});

  @override
  EditBranchScreenState createState() => EditBranchScreenState();
}

class EditBranchScreenState extends State<EditBranchScreen> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current branch details
    nameController = TextEditingController(text: widget.branch.name);
    addressController = TextEditingController(text: widget.branch.address);
    phoneController = TextEditingController(text: widget.branch.phoneNumber);
    emailController = TextEditingController(text: widget.branch.email);
    commentController = TextEditingController(text: widget.branch.comment);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    commentController.dispose();
    super.dispose();
  }

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
        backgroundColor: Colors.green,
        onPressed: () {},
        icon: const Icon(
          Icons.save,
          size: 30,
          color: Colors.white,
        ),
        label: Text("Save", style: CustomStyle.mediumTextWhite),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTextField("Branch Name", nameController),
              buildTextField("Address", addressController),
              buildTextField("Phone Number", phoneController,
                  inputType: TextInputType.phone),
              buildTextField("Email", emailController,
                  inputType: TextInputType.emailAddress),
              buildTextField("Comment", commentController, maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Create an updated branch object
                  Branch updatedBranch = Branch(
                    code: widget.branch.code,
                    id: widget.branch.id,
                    name: nameController.text,
                    address: addressController.text,
                    phoneNumber: phoneController.text,
                    email: emailController.text,
                    comment: commentController.text,
                    createdAt: widget.branch.createdAt,
                    company: widget.branch.company,
                  );

                  // Pass the updated branch back to the previous screen
                  Navigator.pop(context, updatedBranch);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a Card Section
  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: CustomStyle.mediumText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: CustomStyle.mediumTextBRed,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.greyMedium,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.greyMedium,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.redDark,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
