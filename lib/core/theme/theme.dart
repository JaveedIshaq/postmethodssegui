import 'package:flutter/material.dart';

export 'cubit/theme_cubit.dart';

const gray100 = Color(0xffFCFCFC);

TextStyle fontL(
  double size, {
  Color? color,
  double? letterSpacing = -0.1,
  double? lineHeight,
}) =>
    TextStyle(
      fontSize: size,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      color: color ?? gray100,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );
