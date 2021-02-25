import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class MyTheme {}

class NananijiTheme extends MyTheme {
  static Color primaryColor = Colors.lightBlueAccent.shade100;
  static Color secondaryColor = Colors.blueGrey.shade300;
  static Color accentColor = Colors.teal.shade200;

  static final ThemeData theme = ThemeData(
      primaryColor: primaryColor,
      accentColor: accentColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: accentColor)),
      textTheme: GoogleFonts.ralewayTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: accentColor)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: accentColor))),
      popupMenuTheme: PopupMenuThemeData(color: accentColor));
}
