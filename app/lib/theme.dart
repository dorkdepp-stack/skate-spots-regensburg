import 'package:flutter/material.dart';

/// Sharpie skin palette — ported 1:1 from SpotApp Sharpie.dc.html
/// (`const G = '#d9d9d9', K = '#000', MID = '#7c7c7c'`).
const Color kG = Color(0xFFD9D9D9);
const Color kK = Color(0xFF000000);
const Color kMid = Color(0xFF7C7C7C);
const Color kWhite = Color(0xFFFFFFFF);

/// CSS `em` letter-spacing is relative to font-size; Flutter's is absolute px.
double ls(double em, double fontSize) => em * fontSize;

TextStyle freeman(
  double size, {
  Color color = kG,
  double? letterSpacingEm,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'Freeman',
    fontSize: size,
    color: color,
    height: height,
    letterSpacing:
        letterSpacingEm != null ? ls(letterSpacingEm, size) : null,
  );
}

TextStyle fugaz(
  double size, {
  Color color = kWhite,
  double? letterSpacingEm,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'FugazOne',
    fontSize: size,
    color: color,
    height: height,
    letterSpacing:
        letterSpacingEm != null ? ls(letterSpacingEm, size) : null,
  );
}

TextStyle stint(
  double size, {
  Color color = kG,
  double letterSpacingEm = 0.02,
  double opacity = 0.7,
}) {
  return TextStyle(
    fontFamily: 'StintUltraCondensed',
    fontSize: size,
    color: color.withValues(alpha: opacity),
    letterSpacing: ls(letterSpacingEm, size),
  );
}

/// Small uppercase meta labels — the pattern used everywhere for
/// distances, timestamps, and status pills (`font-size:10px;
/// text-transform:uppercase;letter-spacing:.1em`).
TextStyle meta(
  double size, {
  Color color = kG,
  double letterSpacingEm = 0.1,
  FontWeight? weight,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    fontSize: size,
    color: color,
    letterSpacing: ls(letterSpacingEm, size),
    fontWeight: weight,
  );
}

TextStyle inter(
  double size, {
  Color color = kG,
  double? height,
  FontWeight weight = FontWeight.w400,
}) {
  return TextStyle(
    fontFamily: 'Inter',
    fontSize: size,
    color: color,
    height: height,
    fontWeight: weight,
  );
}

ThemeData buildSpotAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kK,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.dark(
      surface: kK,
      primary: kG,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kK,
      selectionColor: Color(0x33000000),
      selectionHandleColor: kK,
    ),
  );
}
