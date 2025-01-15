import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNormalButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool fullWidth;
  final Color backgroundColor;
  final Color textColor;
  final void Function()? onPressed;

  const CustomNormalButton({
    super.key,
    required this.label,
    this.icon,
    this.fullWidth = false,
    this.backgroundColor = CustomStyle.greyDark,
    this.textColor = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          overlayColor: CustomStyle.redLight,
          minimumSize: fullWidth ? const Size(double.infinity, 50) : null,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: backgroundColor, width: 0.0),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: icon != null
            ? Icon(
                icon,
                color: Colors.white,
                size: 25.0,
              )
            : null,
        label: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 20,
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}


class CustomBasicButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;

  const CustomBasicButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
