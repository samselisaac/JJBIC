import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle montserratStyle({
  double fontSize = 16,
  Color color = Colors.white,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return GoogleFonts.montserrat(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}

TextStyle openSansStyle({
  double fontSize = 16,
  Color color = Colors.white,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return GoogleFonts.openSans(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}