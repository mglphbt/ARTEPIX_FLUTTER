import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme get textTheme {
    return GoogleFonts.manropeTextTheme().copyWith(
      displayLarge: GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.02,
      ),
      displayMedium: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.01,
      ),
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  static TextStyle h2({Color? color}) =>
      textTheme.displayMedium!.copyWith(color: color, fontSize: 20);

  static TextStyle label({Color? color}) =>
      textTheme.labelLarge!.copyWith(color: color);

  static TextStyle caption({Color? color}) =>
      textTheme.bodyMedium!.copyWith(color: color, fontSize: 12);

  static TextStyle priceSmall({Color? color}) =>
      textTheme.labelLarge!.copyWith(color: color, fontWeight: FontWeight.bold);
}
