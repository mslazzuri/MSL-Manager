import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  
  textTheme: TextTheme(
   
    displayLarge: GoogleFonts.sourceCodePro(
      fontSize: 30,
      fontWeight: FontWeight.w400,
      color: Colors.white
    ),
    
    displayMedium: GoogleFonts.sourceCodePro(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.white
    ),
    
    displaySmall: GoogleFonts.sourceCodePro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white
    ),

  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey[900],
      foregroundColor: Colors.white,
      textStyle: GoogleFonts.sourceCodePro(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  )
);