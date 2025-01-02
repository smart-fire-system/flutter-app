import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStyle {
  static const Color redDark = Color.fromARGB(255, 180, 40, 60);
  static const Color redMedium = Color.fromARGB(255, 238, 54, 78);
  static const Color redLight = Color.fromARGB(255, 247, 108, 127);
  static const Color greyDark = Color.fromARGB(255, 80, 82, 84);
  static const Color greyMedium = Color.fromARGB(255, 144, 147, 149);
  static const Color greyLight = Color.fromARGB(255, 189, 189, 189);
  static const Color greySuperLight = Color.fromARGB(255, 238, 237, 237);

  static final TextStyle navBarText = GoogleFonts.cairo(
      fontSize: 12, color: greyLight, fontWeight: FontWeight.w500);

  static final TextStyle navBarTextHighLighted = GoogleFonts.cairo(
      fontSize: 14, color: redDark, fontWeight: FontWeight.w700);

  static final TextStyle appBarText = GoogleFonts.cairo(
      fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500);

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
  static final TextStyle mediumTextWhite = GoogleFonts.cairo(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500);
  static final TextStyle mediumTextB = GoogleFonts.cairo(
      fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700);
  static final TextStyle mediumTextBRed = GoogleFonts.cairo(
      fontSize: 18, color: redDark, fontWeight: FontWeight.w700);

  static final TextStyle smallText = GoogleFonts.cairo(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  static final TextStyle smallTextRed = GoogleFonts.cairo(
      fontSize: 16, color: redDark, fontWeight: FontWeight.w500);
  static final TextStyle smallTextGrey = GoogleFonts.cairo(
      fontSize: 16, color: greyDark, fontWeight: FontWeight.w500);
  static final TextStyle smallTextB = GoogleFonts.cairo(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700);

  static final TextStyle smallTextBWhite = GoogleFonts.cairo(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700);


  static final ButtonStyle normalButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    overlayColor: redLight,
    minimumSize: const Size(double.infinity, 50),
    padding: EdgeInsets.zero,
    alignment: Alignment.center,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: greyDark, width: 2.0),
      borderRadius: BorderRadius.circular(24),
    ),
  );

  static final ButtonStyle normalButtonRed = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    minimumSize: const Size(double.infinity, 50),
    padding: EdgeInsets.zero,
    alignment: Alignment.center,
  );

  static final ButtonStyle normalButtonGreen = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    minimumSize: const Size(double.infinity, 50),
    padding: EdgeInsets.zero,
    alignment: Alignment.center,
  );

  static final TextStyle normalButtonText = GoogleFonts.cairo(
      fontSize: 20, color: redDark, fontWeight: FontWeight.w600);
  static final TextStyle normalButtonTextMedium = GoogleFonts.cairo(
      fontSize: 18, color: redDark, fontWeight: FontWeight.w500);
  static final TextStyle normalButtonTextSmall = GoogleFonts.cairo(
      fontSize: 16, color: redDark, fontWeight: FontWeight.w500);

  static final TextStyle normalButtonTextWhite = GoogleFonts.cairo(
      fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600);
  static final TextStyle normalButtonTextMediumWhite = GoogleFonts.cairo(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500);
  static final TextStyle normalButtonTextSmallWhite = GoogleFonts.cairo(
      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500);
}
