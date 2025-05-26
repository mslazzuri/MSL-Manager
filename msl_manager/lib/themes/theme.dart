import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msl_manager/themes/globals.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(
    seedColor: background,
    primary: black,
    secondary: lightBackground,
    tertiary: neonGreen,
  ),
  
  textTheme: TextTheme(
   
    displayLarge: GoogleFonts.sourceCodePro(
      fontSize: 30,
      fontWeight: FontWeight.w400,
      color: gray,
    ),
    
    displayMedium: GoogleFonts.sourceCodePro(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: gray
    ),
    
    displaySmall: GoogleFonts.sourceCodePro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: gray
    ),

    headlineLarge: GoogleFonts.sourceCodePro(
      fontSize: 30,
      fontWeight: FontWeight.w400,
      color: black
    ),

    headlineMedium: GoogleFonts.sourceCodePro(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: black
    ),

    headlineSmall: GoogleFonts.sourceCodePro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: black
    ),

    bodySmall: GoogleFonts.sourceCodePro(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: black
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryButtonFillColor,
      foregroundColor: primaryButtonTextColor,
      textStyle: GoogleFonts.sourceCodePro(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      fixedSize: const Size(250, 50),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: secondaryButtonFillColor,
      foregroundColor: primaryButtonTextColor,
      overlayColor: black,
      textStyle: GoogleFonts.sourceCodePro(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      fixedSize: const Size(250, 50),
    )
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: inputTextFillColor,

    labelStyle: GoogleFonts.sourceCodePro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: textDark,
    ),

    prefixIconColor: lightBackground,
    suffixIconColor: lightBackground,

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: inputTextBorderColor,
        width: 0,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: inputTextBorderColor,
        width: 2,
      ),  
    ),
    
    hintStyle: GoogleFonts.sourceCodePro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: lightBackground,
    ),
  ),

  scaffoldBackgroundColor: background,
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: GoogleFonts.sourceCodePro(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  ),

  dialogTheme: DialogTheme(
    backgroundColor: background,
    titleTextStyle: GoogleFonts.sourceCodePro(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: neonGreen
    ),
    contentTextStyle: GoogleFonts.sourceCodePro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),

  ),
);