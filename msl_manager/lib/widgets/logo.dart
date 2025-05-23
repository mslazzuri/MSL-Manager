import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  final double fontSize;
  final Color color;

  const Logo({
    super.key,
    this.fontSize = 60,
    Color? color,
  }) : color = color ?? const Color(0xFF263238); // Colors.blueGrey[900]

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double breakpoint = 500;
    final responsiveFontSize = screenWidth > breakpoint ? fontSize : fontSize * 0.7;
    
    return Text(
      '{MSL}.',
      style: GoogleFonts.sourceCodePro(
        fontSize: responsiveFontSize,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 2,
      ),
    );
  }
}