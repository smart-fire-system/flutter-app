import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStyle {
  static final TextStyle appBarText = GoogleFonts.cairo(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700);

  static final TextStyle largeText30 = GoogleFonts.cairo(
      fontSize: 30, color: Colors.black, fontWeight: FontWeight.w500);
  static final TextStyle largeText30B = GoogleFonts.cairo(
      fontSize: 30, color: Colors.black, fontWeight: FontWeight.w700);

  static final TextStyle largeText25 = GoogleFonts.cairo(
      fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500);
  static final TextStyle largeText25B = GoogleFonts.cairo(
      fontSize: 25, color: Colors.black, fontWeight: FontWeight.w700);

  static final TextStyle largeText = GoogleFonts.cairo(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500);
  static final TextStyle largeTextB = GoogleFonts.cairo(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700);

  static final TextStyle mediumText = GoogleFonts.cairo(
      fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500);
  static final TextStyle mediumTextB = GoogleFonts.cairo(
      fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700);

  static final TextStyle smallText = GoogleFonts.cairo(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  static final TextStyle smallTextB = GoogleFonts.cairo(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700);

  static final TextStyle smallTextGrey = GoogleFonts.cairo(
      fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500);

  static final ButtonStyle normalButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    minimumSize: const Size(double.infinity, 50),
    padding: EdgeInsets.zero,
    alignment: Alignment.center,
  );
  static final TextStyle normalButtonText = GoogleFonts.cairo(
      fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600);
  static final TextStyle normalButtonTextMedium = GoogleFonts.cairo(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500);
  static final TextStyle normalButtonTextSmall = GoogleFonts.cairo(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500);
}
