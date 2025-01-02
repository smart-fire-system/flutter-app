import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? maxLines;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.inputType,
    this.maxLines,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: CustomStyle.mediumText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: CustomStyle.smallTextBRed,
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

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final int? maxLines;
  final IconData? icon;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.inputType,
    this.maxLines,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: CustomStyle.mediumText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: CustomStyle.smallTextBRed,
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
