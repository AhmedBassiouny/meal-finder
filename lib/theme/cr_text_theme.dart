import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle wTextStyle = TextStyle(
  fontFamily: GoogleFonts.robotoSlab().fontFamily,
  color: Colors.black,
  fontWeight: FontWeight.normal,
);

final crTextTheme = TextTheme(
  displaySmall: wTextStyle.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
  headlineSmall: wTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
  titleMedium: wTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
  bodyMedium: wTextStyle.copyWith(fontSize: 14),
);
