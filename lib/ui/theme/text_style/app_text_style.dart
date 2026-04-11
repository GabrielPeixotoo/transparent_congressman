import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle poppins2 = GoogleFonts.poppins();

  static TextStyle poppins1 = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
  );
  static TextStyle poppins3 = GoogleFonts.poppins().copyWith(fontWeight: FontWeight.bold);
}
