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
      color: Colors.blueGrey[900]
    ),

    headlineMedium: GoogleFonts.sourceCodePro(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.blueGrey[900]
    ),

    headlineSmall: GoogleFonts.sourceCodePro(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.blueGrey[600]
    )

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
      fixedSize: const Size(250, 50),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[200],
      foregroundColor: Colors.blueGrey[900],
      textStyle: GoogleFonts.sourceCodePro(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: Colors.blueGrey[900]!,
          width: 1,
        )
      ),
      fixedSize: const Size(250, 50),
    )
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
    
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: Colors.blueGrey[900]!,
        width: 1,
      ),  
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: Colors.blueGrey[900]!,
        width: 2,
      ),  
    ),

    hintStyle: GoogleFonts.sourceCodePro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.grey[600],
    ),
  ),

  scaffoldBackgroundColor: Colors.blueGrey[900],
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: GoogleFonts.sourceCodePro(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  ),
);